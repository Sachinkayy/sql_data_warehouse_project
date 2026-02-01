-- Now that we have created our BRONZE and SILVER layer, we will be created the GOLD layer based on the clean SILVER layer data --




USE GOLD;



-- CREATING THE CUSTOMERS DIMENSION --

-- extracting all the columns from crm customers data
SHOW COLUMNS IN `SILVER`.CRM_CUST_INFO ;



-- creating the Customers Dimension view for gold layer 
CREATE OR REPLACE VIEW `GOLD`.dim_customers AS (
		SELECT 
		 ROW_NUMBER() OVER (ORDER BY cst_id) as customer_key -- generating surrogate key for the object
		,ci.cst_id as customer_id
		,ci.cst_key as customer_number
		,ci.cst_firstname as first_name
		,ci.cst_lastname as last_name
		,la.cntry as country
		,ci.cst_marital_status as marital_status
		,CASE 
			WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the MASTER for gender info
			ELSE COALESCE(ca.gen,'n/a')
		END as gender
		,ca.bdate as birthdate
		,ci.cst_create_date as create_date
		FROM 
		`SILVER`.CRM_CUST_INFO CI -- main master table from crm containing the customers_ data
        
		LEFT JOIN `SILVER`.ERP_CUST_AZ12 CA -- connecting the customers data from erp table
		ON CI.CST_KEY = CA.CID

		LEFT JOIN `SILVER`.ERP_LOC_A101 la -- connecting the customer location data from erp table
		ON CI.CST_KEY = LA.CID
);


-- querying the view so created
SELECT * FROM `GOLD`.dim_customers;










-- ---------------------------------------------------------------
-- creating the Products Dimension view for gold layer 

SHOW COLUMNS IN `SILVER`.CRM_PRD_INFO ;


-- creating the Products Dimension view for gold layer 
CREATE OR REPLACE VIEW `GOLD`.dim_products AS (
SELECT 
 ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) as product_key -- generating surrogate key for the object
,pn.prd_id as product_id
,pn.prd_key as product_number
,pn.prd_nm as product_name
,pn.cat_id as category_id
,pc.cat as category
,pc.subcat as subcategory
,pc.maintenance
,pn.prd_cost as cost
,pn.prd_line as product_line
,pn.prd_start_dt as start_date

FROM 
`SILVER`.CRM_PRD_INFO pn
LEFT JOIN `SILVER`.ERP_PX_CAT_G1V2 pc
ON pn.cat_id = pc.id

WHERE prd_end_dt IS NULL -- Filter out all historical data
)
;

-- querying the view so created
SELECT * FROM `GOLD`.DIM_PRODUCTS;






-- ---------------------------------------------------------------
-- creating the SALES FACT view for gold layer 

CREATE OR REPLACE VIEW `GOLD`.fact_sales AS (
SELECT 
	sd.sls_ord_num AS order_number,
	-- sd.sls.prd_key,  -- >removing this as we are adding the surrogate which was generated in the dim table
	pr.product_key,	-- > surrogate key which was generated in the dim table

	-- sd.sls_cust_id,  -- > removing this as we are adding the surrogate which was generated in the dim table
	cu.customer_key,

	sd.sls_order_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
	FROM 
	`SILVER`.CRM_SALES_DETAILS sd
	LEFT JOIN `gold`.dim_products pr 
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN `gold`.dim_customers cu
	ON sd.sls_cust_id = cu.customer_id
);


select * from `gold`.fact_sales;


-- Foreign Key Integrity (Dimensions) --
SELECT * 
FROM `GOLD`.FACT_SALES F
LEFT JOIN `GOLD`.DIM_CUSTOMERS C
ON C.CUSTOMER_KEY = F.CUSTOMER_KEY
LEFT JOIN `GOLD`.DIM_PRODUCTS P
ON P.PRODUCT_KEY = F.PRODUCT_KEY
WHERE C.CUSTOMER_KEY IS NULL -- > checking the cutomer dim integrity
OR P.PRODUCT_KEY IS NULL -- > checking the product dim integrity
;





SELECT 
DISTINCT
ci.cst_gndr
,ca.gen
,CASE 
	WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the MASTER for gender info
    ELSE COALESCE(ca.gen,'n/a')
END as new_gen
FROM 
`SILVER`.CRM_CUST_INFO CI
LEFT JOIN `SILVER`.ERP_CUST_AZ12 CA
ON CI.CST_KEY = CA.CID

LEFT JOIN `SILVER`.ERP_LOC_A101 la
ON CI.CST_KEY = LA.CID
ORDER BY 1,2;