/* 

:::Validation for Bronze layer tables:::
This script checks for the data issues in the bronze layer tables before ingesting them into the silver layer

*/

-- switching to bronze layer
Use Bronze;

-- selecting the table 
SELECT * FROM crm_cust_info LIMIT 1000;


-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Primary Key Check
-- Expectation: No Result

-- check for nulls or duplicates in Primary Key > getting values
SELECT cst_id, 
COUNT(*)
FROM crm_cust_info
GROUP BY 1 
HAVING COUNT(*) >1;

-- above query shows results which means we do have cases where muliple rows for single primary key are present,
-- hence we will have you pick one record only out of those cases using WINDOW FUNCTION
SELECT * FROM (
SELECT *, row_number() over(partition by cst_id order by cst_create_date desc) r
FROM crm_cust_info) e
WHERE r =1; 



-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: UNWANTED SPACES CHECK
-- Expectation: No Result

-- checking firstname > getting values
SELECT cst_firstname from crm_cust_info 
where cst_firstname != TRIM(cst_firstname);

-- checking lastname > getting values
SELECT cst_lastname from crm_cust_info 
where cst_lastname != TRIM(cst_lastname);

-- checking cst_gndr > not getting values
SELECT cst_gndr from crm_cust_info 
where cst_gndr != TRIM(cst_gndr);



-- ------------------------------------------------------------------------- --
-- >>>>CHECK3: CHECKING DATA STANDARDIZATION AND CONSISTENCY
-- Expectation: LESS UNIQUE VALUES

-- checking values for gender and marital status
SELECT DISTINCT
-- cst_gndr 
cst_marital_status
from crm_cust_info ;

-- ----------------------------------------------------------------------------- --
-- >> Now, using the above cleaning stratgey we will load the tables in the silver layer from broze layer


-- GENERATING/INSERTING FINAL QUERY w CLEANED DATA FOR BRONZE.CRM_CUST_INFO to insert to SILVER.CRM_CUST_INFO

TRUNCATE TABLE `SILVER`.`crm_cust_info`;

INSERT INTO `SILVER`.`crm_cust_info`
(`cst_id`,
`cst_key`,
`cst_firstname`,
`cst_lastname`,
`cst_marital_status`,
`cst_gndr`,
`cst_create_date`)
 (
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_marital_status))='M' THEN 'Married'
    WHEN UPPER(TRIM(cst_marital_status))='S' THEN 'Single'
    ELSE 'n/a'
END AS cst_marital_status,
CASE 
	WHEN UPPER(TRIM(cst_gndr))='M' THEN 'Male'
    WHEN UPPER(TRIM(cst_gndr))='F' THEN 'Female'
    ELSE 'n/a'
END AS cst_gndr,
cst_create_date

FROM (
	SELECT *, row_number() over(partition by cst_id order by cst_create_date desc) r
	FROM `bronze`.`crm_cust_info`
) e
WHERE r =1); 



-- ---------------------------------------------------------------------------
-- CHECKING THE SILVER LAYER DATA AFTER THE CLEANED DATA INSERTION
-- ---------------------------------------------------------------------------

-- switching to SILVER layer
Use SILVER;

-- selecting the table 
SELECT * FROM crm_cust_info LIMIT 1000;


-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Primary Key Check
-- Expectation: No Result

-- check for nulls or duplicates in Primary Key > getting values
SELECT cst_id, 
COUNT(*)
FROM crm_cust_info
GROUP BY 1 
HAVING COUNT(*) >1;


-- ------------------------------------------------------------------------- --
-- >>>>CHECK2: UNWANTED SPACES CHECK
-- Expectation: No Result

-- checking firstname > getting values
SELECT cst_firstname from crm_cust_info 
where cst_firstname != TRIM(cst_firstname);

-- checking lastname > getting values
SELECT cst_lastname from crm_cust_info 
where cst_lastname != TRIM(cst_lastname);

-- checking cst_gndr > not getting values
SELECT cst_gndr from crm_cust_info 
where cst_gndr != TRIM(cst_gndr);

-- ------------------------------------------------------------------------- --
-- >>>>CHECK3: CHECKING DATA STANDARDIZATION AND CONSISTENCY
-- Expectation: LESS UNIQUE VALUES

-- checking values for gender and marital status
SELECT DISTINCT
cst_gndr 
-- cst_marital_status
from crm_cust_info ;


