
======================================================================================================================
This script
Loads data from the local system location to the tables sitting in a specific database,
in order to do that, the sql should be enabled to accept the LOCAL_INFILE command, by default it might be disabled.


-- below command checks the local_infile variable, if its OFF or 0, we need to enable it
SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- if it's OFF (0), turn it ON:
SET GLOBAL local_infile = 1;

======================================================================================================================




-- switching to the database;
USE BRONZE;





-- === LOADING  crm_cust_info ===

-- truncating the table 
TRUNCATE TABLE crm_cust_info ;

-- loading the file from local to the table
LOAD DATA LOCAL INFILE '/Users/sachin.k.lv/Documents/MySpace/sql_data_warehouse_project/datasets/source_crm/cust_info.csv'
INTO TABLE crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date);

-- checking the data after loading
SELECT * FROM crm_cust_info;
-- checking the count after loading
SELECT COUNT(*) FROM crm_cust_info;




-- === LOADING  crm_prd_info === --

-- truncating the table 
TRUNCATE TABLE crm_prd_info;

-- loading the file from local to the table
LOAD DATA LOCAL INFILE '/Users/sachin.k.lv/Documents/MySpace/sql_data_warehouse_project/datasets/source_crm/prd_info.csv'
INTO TABLE crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt);

-- checking the data after loading
SELECT * FROM crm_prd_info;
-- checking the count after loading
SELECT COUNT(*) FROM crm_prd_info;





-- === LOADING  crm_sales_details === --
-- truncating the table 
TRUNCATE TABLE crm_sales_details;

-- loading the file from local to the table
LOAD DATA LOCAL INFILE '/Users/sachin.k.lv/Documents/MySpace/sql_data_warehouse_project/datasets/source_crm/sales_details.csv'
INTO TABLE crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price);

-- checking the data after loading
SELECT * FROM crm_sales_details;
-- checking the count after loading
SELECT COUNT(*) FROM crm_sales_details;



-- We can also do the same data load from the UI in MySQL, this step might be slower than the bulk load we were doing above --
-- Steps:

-- To import a CSV into a table:
-- Open MySQL Workbench and connect to your server.
-- In the Schemas pane, select your database.
-- Right-click on the table you want to load into → choose
-- Table Data Import Wizard (or sometimes “Import Data Table” depending on version).
-- Choose your CSV file.
-- Map columns in the file to columns in the table (Workbench will try to auto-map headers).
-- Click Next / Import till it finishes.

SELECT count(*) FROM `erp_cust_az12`;
SELECT count(*) FROM `erp_loc_a101`;
SELECT count(*) FROM `erp_px_cat_g1v2`;

