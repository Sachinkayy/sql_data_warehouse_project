/* 

:::Validation for Bronze layer tables:::
This script checks for the data issues in the bronze layer tables before ingesting them into the silver layer

*/

-- switching to bronze layer
Use BRONZE;

-- selecting the table 
SELECT * FROM `bronze`.erp_loc_a101 LIMIT 1000;


-- checking the columns in the table 
show columns  in `bronze`.erp_loc_a101;




-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Checking Country column unique values
-- result: we have got differnet values for describing the same info, ex: US and United States
SELECT DISTINCT CNTRY FROM  `bronze`.erp_loc_a101 ;






-- ----------------------------------------------------------------------------- --
-- >> Now, using the above cleaning stratgey we will load the tables in the silver layer from broze layer
-- PREPARIG THE QUERY THAT WE WILL USE TO INSERT DATA INTO SILVER.erp_cust_az12 


SELECT 
-- removing the hiphen from the bronze table as we dont have the key like that in our silver Layer table that is to be connected
    REPLACE(cid, '-','') CID
    ,CASE 
		WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
        WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
        ELSE TRIM(CNTRY)
	END AS CNTRY
FROM `bronze`.erp_loc_a101
-- below we are checking if there are any rows from bronze erp table which wont have a match in silver crm table
-- result: no such rows
-- where
-- REPLACE(cid, '-','')
-- NOT IN (SELECT DISTINCT cst_key FROM `silver`.crm_cust_info)
;





-- GENERATING/INSERTING FINAL QUERY w CLEANED DATA FOR BRONZE.crm_sales_details to insert to SILVER.crm_sales_details

TRUNCATE TABLE `SILVER`.`erp_loc_a101`;

INSERT INTO `SILVER`.`erp_loc_a101`
(
	 `cid`
	,`cntry`
)
 (
SELECT 
-- removing the hiphen from the bronze table as we dont have the key like that in our silver Layer table that is to be connected
    REPLACE(cid, '-','') CID
    ,CASE 
		WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
        WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
        WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
        ELSE TRIM(CNTRY)
	END AS CNTRY
FROM `bronze`.erp_loc_a101
);


-- ---------------------------------------------------------------------------
-- CHECKING THE SILVER LAYER DATA AFTER THE CLEANED DATA INSERTION
-- ---------------------------------------------------------------------------

-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Checking Country column unique values
-- result: we have got differnet values for describing the same info, ex: US and United States
SELECT DISTINCT CNTRY FROM  `SILVER`.erp_loc_a101 ;



SELECT * FROM  `silver`.erp_loc_a101 ;