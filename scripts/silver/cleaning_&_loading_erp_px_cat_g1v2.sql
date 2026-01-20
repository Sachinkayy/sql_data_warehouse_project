/* 

:::Validation for Bronze layer tables:::
This script checks for the data issues in the bronze layer tables before ingesting them into the silver layer

*/

-- switching to bronze layer
Use BRONZE;

-- selecting the table 
SELECT * FROM `bronze`.erp_px_cat_g1v2 LIMIT 1000;


-- checking the columns in the table 
show columns  in `bronze`.erp_px_cat_g1v2;



-- ------------------------------------------------------------------------- --
-- >>>>CHECK1: Checking unwanted spaces in the columns
-- result: we have no rows
SELECT * FROM  `bronze`.erp_px_cat_g1v2 
WHERE
cat != TRIM(cat)
OR 
subcat != TRIM(subcat)
OR
maintenance != TRIM(maintenance)
;



-- ------------------------------------------------------------------------- --
-- >>>>CHECK2 : Checking Unique values in the columns
-- result: No data inconsistencies found
SELECT DISTINCT CAT,SUBCAT,MAINTENANCE FROM  `bronze`.erp_px_cat_g1v2 

;



-- ----------------------------------------------------------------------------- --
-- >> Now, As we have found no issues in the data for this table we will directly insert the data from bronze to silver layer
-- PREPARIG THE QUERY THAT WE WILL USE TO INSERT DATA INTO SILVER.erp_cust_az12 


SELECT 
	id,
	cat,
	subcat, 
	maintenance
FROM 
`bronze`.erp_px_cat_g1v2 
;






-- GENERATING/INSERTING FINAL QUERY w CLEANED DATA FOR BRONZE.crm_sales_details to insert to SILVER.crm_sales_details

TRUNCATE TABLE `SILVER`.`erp_px_cat_g1v2`;

INSERT INTO `SILVER`.`erp_px_cat_g1v2`
(
	 `id`
	,`cat`
	,`subcat`
    ,`maintenance`
)
 (
 SELECT 
	id,
	cat,
	subcat, 
	maintenance
FROM 
`bronze`.erp_px_cat_g1v2 
);


-- ---------------------------------------------------------------------------
-- CHECKING THE SILVER LAYER DATA AFTER THE CLEANED DATA INSERTION
-- ---------------------------------------------------------------------------


SELECT * FROM  `silver`.erp_px_cat_g1v2 ;