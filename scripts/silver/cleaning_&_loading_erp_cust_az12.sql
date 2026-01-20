/* 

:::Validation for Bronze layer tables:::
This script checks for the data issues in the bronze layer tables before ingesting them into the silver layer

*/

-- switching to bronze layer
Use BRONZE;

-- selecting the table 
SELECT * FROM `bronze`.erp_cust_az12 LIMIT 1000;


-- checking the columns in the table 
show columns  in `bronze`.erp_cust_az12;




-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Invalid dates check (Checking out of range dates)
-- Expectation: Valid dates formats and no 0 or -ve dates

-- checking bdate
-- We have got data quality issues in the bday date columns as we have old of range dates in the bdate column
SELECT * FROM  `bronze`.erp_cust_az12 
where 
-- checking negative or 0 in the bdate
bdate <=0 

-- checking for people who are more than 100 years old
OR bdate < '1924-01-01'

-- checking for people who have bday equal to current date
OR bdate > current_date();



-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: Checking Gender column unique values
-- result: we have got differnet values for describing the same info, ex: Male and M both are present
SELECT DISTINCT GEN FROM  `bronze`.erp_cust_az12 ;






-- ----------------------------------------------------------------------------- --
-- >> Now, using the above cleaning stratgey we will load the tables in the silver layer from broze layer
-- PREPARIG THE QUERY THAT WE WILL USE TO INSERT DATA INTO SILVER.erp_cust_az12 


SELECT 
-- removing the first 3 characters from the cid as we dont have the key like that in our silver Layer table that is to be connected
	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,length(cid))
        ELSE cid
	END as CID
    ,CASE 
		WHEN bdate > current_date() THEN NULL
        ELSE bdate
	END as BDATE
	,CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END as gen
FROM `bronze`.erp_cust_az12
-- below we are checking if there are any rows from bronze erp table which wont have a match in silver crm table
-- result: no such rows
-- where
-- CASE 
-- 		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,length(cid))
--         ELSE cid
-- 	END NOT IN (SELECT DISTINCT cst_key FROM `silver`.crm_cust_info)
;





-- GENERATING/INSERTING FINAL QUERY w CLEANED DATA FOR BRONZE.crm_sales_details to insert to SILVER.crm_sales_details

TRUNCATE TABLE `SILVER`.`erp_cust_az12`;

INSERT INTO `SILVER`.`erp_cust_az12`
(
	 `cid`
	,`bdate`
	,`gen`
)
 (
SELECT 
-- removing the first 3 characters from the cid as we dont have the key like that in our silver Layer table that is to be connected
	CASE 
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4,length(cid))
        ELSE cid
	END as CID
    ,CASE 
		WHEN bdate > current_date() THEN NULL
        ELSE bdate
	END as BDATE
	,CASE 
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		ELSE 'n/a'
	END as gen
FROM `bronze`.erp_cust_az12);


-- ---------------------------------------------------------------------------
-- CHECKING THE SILVER LAYER DATA AFTER THE CLEANED DATA INSERTION
-- ---------------------------------------------------------------------------



-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Invalid dates check (Checking out of range dates)
-- Expectation: Valid dates formats and no 0 or -ve dates

-- checking bdate
-- We have got data quality issues in the bday date columns as we have old of range dates in the bdate column
SELECT * FROM  `silver`.erp_cust_az12 
where 
-- checking negative or 0 in the bdate
bdate <=0 

-- checking for people who are more than 100 years old
-- OR bdate < '1924-01-01'

-- checking for people who have bday equal to current date
OR bdate > current_date();



-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: Checking Gender column unique values
-- result: we have got differnet values for describing the same info, ex: Male and M both are present
SELECT DISTINCT GEN FROM  `silver`.erp_cust_az12 ;


SELECT * FROM  `silver`.erp_cust_az12 ;