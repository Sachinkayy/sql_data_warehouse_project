-- >> CHOOSING THE DATABSE
USE BRONZE;

-- >> Listing all the tables
SHOW TABLES;


-- >> Looking into the data
SELECT 
prd_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
FROM 
`BRONZE`.`crm_prd_info`;





-- >> CHECKING FOR THE DATA QUALITY before instering data from Broze to Silver layer
-- CHECKING FOR crm_prd_info table

-- listing the columns
show columns in `BRONZE`.`crm_prd_info`;




-- >> PRIMARY KEY CHECK  <<
-- checking for for nulls and duplicates in the primary key column
-- Expectation: No records

SELECT PRD_ID, COUNT(*)
FROM 
`BRONZE`.`crm_prd_info`
GROUP BY 1 
HAVING COUNT(*)>1 OR PRD_ID IS NULL;




-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: UNWANTED SPACES CHECK
-- Expectation: No Result

-- checking PRD_NM > getting values
SELECT PRD_NM from `bronze`.crm_prd_info 
where PRD_NM != TRIM(PRD_NM);

-- ------------------------------------------------------------------------- --
-- >>>>CHECK3: Checking Null and Negative numbers in the column
-- Expectation: No Result, if there are such values handle them while insertion
SELECT PRD_COST from `bronze`.crm_prd_info 
WHERE PRD_COST < 0 OR PRD_COST IS NULL;


-- ------------------------------------------------------------------------- --
-- >>>>CHECK4: CHECKING DATA STANDARDIZATION AND CONSISTENCY
-- Expectation: LESS UNIQUE VALUES

-- checking values for PRD_LINE
SELECT DISTINCT
PRD_LINE 
from`bronze`.crm_prd_info ;

-- ------------------------------------------------------------------------- --
-- >>>>CHECK5: CHECKING INVALID DATE ORDERS
-- Expectation: Correct date and formats along with right business logic

-- checking values for PRD_START_DT and PRD_END_DT
SELECT DISTINCT
* 
from`bronze`.crm_prd_info 
where prd_end_dt < prd_start_dt;
-- ------------------------------------------------------------------------- --




-- PREPARIG THE QUERY THAT WE WILL USE TO INSERT DATA INTO SILVER.CRM_PRD_INFO 
SELECT 
prd_id,
-- splitting and transforming the column info as we have to use it as key to connect
replace(substr(PRD_KEY,1,5),'-','_') AS cat_id,
-- extracting the prd_key from the prd_key
SUBSTRING(PRD_KEY, 7, LENGTH(PRD_KEY)) as prd_key,
prd_nm,
IF(prd_cost IS NULL, 0, prd_cost) as prd_cost,
-- standardizing the prd_line values
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'other Sales'
	WHEN 'T' THEN 'Touring'
    ELSE 'n/a'
END AS prd_line,
cast(prd_start_dt AS DATE) AS prd_start_dt,
-- fixing the invalid dates, i.e., which have end_dates less than the start_dates
CAST(date_add(LEAD(prd_start_dt) OVER(PARTITION BY PRD_KEY ORDER BY prd_start_dt), interval -1 day) AS DATE) AS prd_end_dt
FROM 
`BRONZE`.`crm_prd_info`
-- checking which cat_id is not available in the to be joined table
-- we are seeing 1 cat_id in the crm which is not availble in the erp table
-- WHERE replace(substr(PRD_KEY,1,5),'-','_') NOT IN (
-- select id from `BRONZE`.erp_px_cat_g1v2)

-- checking which prd_key is not available in the to be joined table
-- we are seieng som results, which means that we have some products which dont have any orders in the sales table
-- WHERE SUBSTRING(PRD_KEY, 7, LENGTH(PRD_KEY)) NOT IN (
-- select SLS_PRD_KEY from `BRONZE`.crm_sales_details
-- )
;




-- ----------------------------------------------------------------------------- --
-- >> Now, using the above cleaning stratgey we will load the tables in the silver layer from broze layer


-- GENERATING/INSERTING FINAL QUERY w CLEANED DATA FOR BRONZE.CRM_CUST_INFO to insert to SILVER.CRM_CUST_INFO
TRUNCATE TABLE `SILVER`.`crm_prd_info`;

-- INSETING THE DATA FROM BRONZE TO SILVER
INSERT INTO `SILVER`.`crm_prd_info`
(	`prd_id`,
	`cat_id`,
	`prd_key`,
	`prd_nm`,
	`prd_cost`,
	`prd_line`,
	`prd_start_dt`,
	`prd_end_dt`)
(
SELECT 
prd_id,
-- splitting and transforming the column info as we have to use it as key to connect
replace(substr(PRD_KEY,1,5),'-','_') AS cat_id,
-- extracting the prd_key from the prd_key
SUBSTRING(PRD_KEY, 7, LENGTH(PRD_KEY)) as prd_key,
prd_nm,
IF(prd_cost IS NULL, 0, prd_cost) as prd_cost,
-- standardizing the prd_line values
CASE UPPER(TRIM(prd_line))
	WHEN 'M' THEN 'Mountain'
	WHEN 'R' THEN 'Road'
	WHEN 'S' THEN 'other Sales'
	WHEN 'T' THEN 'Touring'
    ELSE 'n/a'
END AS prd_line,
cast(prd_start_dt AS DATE) AS prd_start_dt,
-- fixing the invalid dates, i.e., which have end_dates less than the start_dates
-- calculating the end date as one dat before the next start date
CAST(date_add(LEAD(prd_start_dt) OVER(PARTITION BY PRD_KEY ORDER BY prd_start_dt), interval -1 day) AS DATE) AS prd_end_dt
FROM 
`BRONZE`.`crm_prd_info`);





-- >> CHECKING FOR THE DATA QUALITY AFTER instering data from Broze to Silver layer
-- CHECKING FOR crm_prd_info table

-- listing the columns
show columns in `SILVER`.`crm_prd_info`;




-- >> PRIMARY KEY CHECK  <<
-- checking for for nulls and duplicates in the primary key column
-- Expectation: No records

SELECT PRD_ID, COUNT(*)
FROM 
`SILVER`.`crm_prd_info`
GROUP BY 1 
HAVING COUNT(*)>1 OR PRD_ID IS NULL;




-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: UNWANTED SPACES CHECK
-- Expectation: No Result

-- checking PRD_NM > getting values
SELECT PRD_NM from `SILVER`.crm_prd_info 
where PRD_NM != TRIM(PRD_NM);

-- ------------------------------------------------------------------------- --
-- >>>>CHECK3: Checking Null and Negative numbers in the column
-- Expectation: No Result, if there are such values handle them while insertion
SELECT PRD_COST from `SILVER`.crm_prd_info 
WHERE PRD_COST < 0 OR PRD_COST IS NULL;


-- ------------------------------------------------------------------------- --
-- >>>>CHECK4: CHECKING DATA STANDARDIZATION AND CONSISTENCY
-- Expectation: LESS UNIQUE VALUES

-- checking values for PRD_LINE
SELECT DISTINCT
PRD_LINE 
from`SILVER`.crm_prd_info ;

-- ------------------------------------------------------------------------- --
-- >>>>CHECK5: CHECKING INVALID DATE ORDERS
-- Expectation: Correct date and formats along with right business logic

-- checking values for PRD_START_DT and PRD_END_DT
SELECT DISTINCT
* 
from`SILVER`.crm_prd_info 
where prd_end_dt < prd_start_dt;
-- ------------------------------------------------------------------------- --


-- Checking the final table
select * from `SILVER`.crm_prd_info ;


