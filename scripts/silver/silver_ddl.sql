/*
===============================================================================
DDL Script: Create SILVER Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'SILVER' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'SILVER' Tables
===============================================================================
*/

-- switching to the SILVER data base
USE SILVER;

-- dropping the table if it exists
DROP TABLE IF EXISTS crm_cust_info;

-- Creating the crm_cust_info table
CREATE TABLE IF NOT EXISTS crm_cust_info (
    cst_id              INT,
    cst_key             VARCHAR(50),
    cst_firstname       VARCHAR(50),
    cst_lastname        VARCHAR(50),
    cst_marital_status  VARCHAR(50),
    cst_gndr            VARCHAR(50),
    cst_create_date     DATE,
    dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP()
);


-- dropping the table if it exists
DROP TABLE IF EXISTS `SILVER`.crm_prd_info;

-- Creating the crm_prd_info table
CREATE TABLE IF NOT EXISTS `SILVER`.crm_prd_info (
    prd_id       INT,
    cat_id		 VARCHAR(50),
    prd_key      VARCHAR(50),
    prd_nm       VARCHAR(50),
    prd_cost     INT,
    prd_line     VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt   DATE,
	dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP()

);

-- dropping the table if it exists
DROP TABLE IF EXISTS crm_sales_details;

-- Creating the crm_sales_details table
CREATE TABLE IF NOT EXISTS crm_sales_details (
    sls_ord_num  VARCHAR(50),
    sls_prd_key  VARCHAR(50),
    sls_cust_id  INT,
    sls_order_dt DATE,
    sls_ship_dt  DATE,
    sls_due_dt   DATE,
    sls_sales    INT,
    sls_quantity INT,
    sls_price    INT,
	dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP()

);


-- dropping the table if it exists
DROP TABLE IF EXISTS erp_loc_a101;

-- Creating the erp_loc_a101 table
CREATE TABLE IF NOT EXISTS erp_loc_a101 (
    cid    VARCHAR(50),
    cntry  VARCHAR(50),
	dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP()

);



-- dropping the table if it exists
DROP TABLE IF EXISTS erp_cust_az12;

-- Creating the erp_cust_az12 table
CREATE TABLE IF NOT EXISTS erp_cust_az12 (
    cid    VARCHAR(50),
    bdate  DATE,
    gen    VARCHAR(50),
	dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP()

);



-- dropping the table if it exists
DROP TABLE IF EXISTS erp_px_cat_g1v2;

-- Creating the erp_px_cat_g1v2 table
CREATE TABLE IF NOT EXISTS erp_px_cat_g1v2 (
    id           VARCHAR(50),
    cat          VARCHAR(50),
    subcat       VARCHAR(50),
    maintenance  VARCHAR(50),
	dwh_create_date     DATETIME DEFAULT CURRENT_TIMESTAMP()

);
