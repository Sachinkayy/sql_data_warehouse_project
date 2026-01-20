/* 

:::Validation for Bronze layer tables:::
This script checks for the data issues in the bronze layer tables before ingesting them into the silver layer

*/

-- switching to bronze layer
Use Bronze;

-- selecting the table 
SELECT * FROM crm_sales_details LIMIT 1000;


-- checking the columns in the table 
show columns  in `bronze`.crm_sales_details;






-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Checking the column with leading or trailing spaces
-- Expectation: No Result

SELECT *  FROM `bronze`.crm_sales_details 
WHERE 
sls_ord_num != TRIM(sls_ord_num);


-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: Checking the keys columns (in case we have some key which is available in 1 table and not in another)
-- Expectation: No Result


-- checking sls_prd_key
SELECT *  FROM `bronze`.crm_sales_details 
WHERE 
sls_prd_key NOT IN (
	SELECT PRD_KEY FROM `SILVER`.crm_prd_info
);

-- checking sls_cust_id
SELECT *  FROM `bronze`.crm_sales_details 
WHERE 
sls_cust_id NOT IN (
	SELECT cst_id FROM `SILVER`.crm_cust_info
);



-- ------------------------------------------------------------------------- --
-- >>>>CHECK3: Invalid dates check
-- Expectation: Valid dates formats and no 0 or -ve dates

-- checking sls_order_dt
-- we got dates with 0 in them, we can change them to null values
SELECT sls_order_dt FROM  `bronze`.crm_sales_details 
where sls_order_dt <=0;


-- we have got dates in 20130823 (integer form), checking if they are feasible to convert to dates
-- checking the length of the dates (YYYYMMDD)
-- result: we got some bad date enteries
SELECT sls_order_dt FROM  `bronze`.crm_sales_details 
where LENGTH(sls_order_dt) !=8;


-- checking the boundary or upper value of the date present
-- result: no records, upper data boundary is good, lowe boundary has garbage values 
SELECT sls_order_dt FROM  `bronze`.crm_sales_details 
where sls_order_dt > 20500101 OR sls_order_dt < 19000101;



-- checking sls_ship_dt
-- we got dates with 0 in them, we can change them to null values
-- result: no invalid records
SELECT sls_ship_dt FROM  `bronze`.crm_sales_details 
where  LENGTH(sls_ship_dt) !=8 OR sls_ship_dt > 20500101 OR sls_ship_dt < 19000101;



-- checking sls_due_dt
-- we got dates with 0 in them, we can change them to null values
-- result: no invalid records
SELECT sls_due_dt FROM  `bronze`.crm_sales_details 
where  LENGTH(sls_due_dt) !=8 OR sls_due_dt > 20500101 OR sls_due_dt < 19000101;



-- checking if we have any invalid sls_order_dt,i.e., any ship or due date before the order date
-- result: no records
SELECT * FROM  `bronze`.crm_sales_details 
where  sls_order_dt  > sls_ship_dt or sls_order_dt > sls_due_dt;



-- ------------------------------------------------------------------------- --
-- >>>>CHECK4: Checking Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- Sales, Quantity, Price cant be null or negative values
-- result: we got bad results, w all 3 scenarios written above
-- in such a case, we can have the data fixed from the source or at the warehouse based on te=he feedback 
-- provided by the business handlers

SELECT * FROM  `bronze`.crm_sales_details 
where  sls_sales  != sls_quantity * sls_price
OR
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR
sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0;







-- ----------------------------------------------------------------------------- --
-- >> Now, using the above cleaning stratgey we will load the tables in the silver layer from broze layer

-- PREPARIG THE QUERY THAT WE WILL USE TO INSERT DATA INTO SILVER.crm_sales_details 
WITH BASE_DATA AS (
	SELECT 
	sls_ord_num
	,sls_prd_key
	,sls_cust_id
	,CASE 
		WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d')
	END AS sls_order_dt
	,CASE 
		WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d')
	END AS sls_ship_dt
	,CASE 
		WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d')
	END AS sls_due_dt
	,sls_sales
	,sls_quantity
	,CASE
			WHEN sls_price IS NULL OR sls_price <= 0 
			THEN sls_sales / NULLIF(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
	FROM 
	`bronze`.crm_sales_details
)
SELECT 
	 sls_ord_num
	,sls_prd_key
	,sls_cust_id
    ,sls_order_dt
    ,sls_ship_dt
    ,sls_due_dt
	,CASE 
		WHEN (sls_sales IS NULL) OR (sls_sales <=0) OR (sls_sales != sls_quantity * ABS(sls_price))
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales
    ,sls_quantity
    ,sls_price
 FROM BASE_DATA 
;







-- GENERATING/INSERTING FINAL QUERY w CLEANED DATA FOR BRONZE.crm_sales_details to insert to SILVER.crm_sales_details

TRUNCATE TABLE `SILVER`.`crm_sales_details`;

INSERT INTO `SILVER`.`crm_sales_details`
(
	 `sls_ord_num`
	,`sls_prd_key`
	,`sls_cust_id`
    ,`sls_order_dt`
    ,`sls_ship_dt`
    ,`sls_due_dt`
    ,`sls_sales`
    ,`sls_quantity`
    ,`sls_price`
)
 (
 WITH BASE_DATA AS (
	SELECT 
	sls_ord_num
	,sls_prd_key
	,sls_cust_id
	,CASE 
		WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(sls_order_dt, '%Y%m%d')
	END AS sls_order_dt
	,CASE 
		WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(sls_ship_dt, '%Y%m%d')
	END AS sls_ship_dt
	,CASE 
		WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
		ELSE STR_TO_DATE(sls_due_dt, '%Y%m%d')
	END AS sls_due_dt
	,sls_sales
	,sls_quantity
	,CASE
			WHEN sls_price IS NULL OR sls_price <= 0 
			THEN sls_sales / NULLIF(sls_quantity,0)
			ELSE sls_price
		END AS sls_price
	FROM 
	`bronze`.crm_sales_details
)
SELECT 
	 sls_ord_num
	,sls_prd_key
	,sls_cust_id
    ,sls_order_dt
    ,sls_ship_dt
    ,sls_due_dt
	,CASE 
		WHEN (sls_sales IS NULL) OR (sls_sales <=0) OR (sls_sales != sls_quantity * ABS(sls_price))
		THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales
    ,sls_quantity
    ,sls_price
 FROM BASE_DATA 
 ); 


-- ---------------------------------------------------------------------------
-- CHECKING THE SILVER LAYER DATA AFTER THE CLEANED DATA INSERTION
-- ---------------------------------------------------------------------------




-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Checking the column with leading or trailing spaces
-- Expectation: No Result

SELECT *  FROM `bronze`.crm_sales_details 
WHERE 
sls_ord_num != TRIM(sls_ord_num);


-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: Checking the keys columns (in case we have some key which is available in 1 table and not in another)
-- Expectation: No Result


-- checking sls_prd_key
SELECT *  FROM `bronze`.crm_sales_details 
WHERE 
sls_prd_key NOT IN (
	SELECT PRD_KEY FROM `SILVER`.crm_prd_info
);

-- checking sls_cust_id
SELECT *  FROM `bronze`.crm_sales_details 
WHERE 
sls_cust_id NOT IN (
	SELECT cst_id FROM `SILVER`.crm_cust_info
);



-- ------------------------------------------------------------------------- --
-- >>>>CHECK3: Invalid dates check
-- Expectation: Valid dates formats and no 0 or -ve dates

-- checking sls_order_dt
-- result: no records
SELECT sls_order_dt FROM  `silver`.crm_sales_details 
where sls_order_dt <=0;


-- After insertion we have got dates in 2013-08-23 (Date form), checking their length
-- checking the length of the dates (YYYY-MM-DD)
-- result: no records
SELECT sls_order_dt FROM  `silver`.crm_sales_details 
where LENGTH(sls_order_dt) !=10;


-- checking the boundary or upper value of the date present
-- result: no records
SELECT sls_order_dt FROM  `silver`.crm_sales_details 
where sls_order_dt > 20500101 OR sls_order_dt < 19000101;



-- checking sls_ship_dt
-- we got dates with 0 in them, we can change them to null values
-- result: no invalid records
SELECT sls_ship_dt FROM  `silver`.crm_sales_details 
where  LENGTH(sls_ship_dt) !=10 OR sls_ship_dt > 20500101 OR sls_ship_dt < 19000101;



-- checking sls_due_dt
-- we got dates with 0 in them, we can change them to null values
-- result: no invalid records
SELECT sls_due_dt FROM  `silver`.crm_sales_details 
where  LENGTH(sls_due_dt) !=10 OR sls_due_dt > 20500101 OR sls_due_dt < 19000101;



-- checking if we have any invalid sls_order_dt,i.e., any ship or due date before the order date
-- result: no records
SELECT * FROM  `silver`.crm_sales_details 
where  sls_order_dt  > sls_ship_dt or sls_order_dt > sls_due_dt;



-- ------------------------------------------------------------------------- --
-- >>>>CHECK4: Checking Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- Sales, Quantity, Price cant be null or negative values
-- result: no records
SELECT * FROM  `silver`.crm_sales_details 
where  sls_sales  != sls_quantity * sls_price
OR
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR
sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0;



SELECT * FROM `silver`.crm_sales_details ;

