/*
===============================================================================
Quality Checks
===============================================================================
Script Purpose:
    This script performs various quality checks for data consistency, accuracy, 
    and standardization across the 'silver' layer. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.
===============================================================================
*/

-- Table: silver_crm_cust_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectations: No Result

SELECT 
cst_id, 
COUNT(*) 
FROM silver_crm_cust_info
GROUP BY cst_id HAVING COUNT(*) > 1 or cst_id IS NULL;

-- Check for unwanted spaces
-- Expectations: No Result

SELECT cst_firstname 
FROM silver_crm_cust_info
WHERE cst_firstname <> trim(cst_firstname);

-- Data standardization and data consistency
SELECT DISTINCT cst_gndr
FROM silver_crm_cust_info;

-- Table silver_crm_prd_info
-- Check for Nulls or Duplicates in Primary Key
-- Expectations: No Result

SELECT 
prd_id, 
COUNT(*) 
FROM silver_crm_prd_info
GROUP BY prd_id HAVING COUNT(*) > 1 or prd_id IS NULL;

-- Check for unwanted spaces
-- Expectations: No Result

SELECT prd_nm
FROM silver_crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- check for NULLS or Negative Numbers
-- Expectations = No Result

SELECT prd_cost FROM silver_crm_prd_info
WHERE prd_cost < 0 or prd_cost IS NULL;

-- Data standardization and data consistency

SELECT DISTINCT prd_line from silver_crm_prd_info;

SELECT count(*), prd_line FROM silver_crm_prd_info WHERE prd_line = '';

-- check for invalid dates
-- Expectation: No result

SELECT * from silver_crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Table silver_crm_sales_details
-- Check for unwanted spaces
-- Expectations: No Result

SELECT
*
FROM silver_crm_sales_details
WHERE sls_ord_num <> TRIM(sls_ord_num);

SELECT
*
FROM silver_crm_sales_details
WHERE sls_prd_key <> TRIM(sls_prd_key);

-- Check if joining column works
-- Expectations: No result

SELECT * FROM silver_crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver_crm_prd_info);

SELECT * FROM silver_crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver_crm_cust_info);

-- check for invalid dates
-- Expectations: No result (order date can be NULL)

SELECT * FROM silver_crm_sales_details
WHERE sls_due_dt < sls_ship_dt OR sls_ship_dt < sls_order_dt;

SELECT sls_order_dt FROM silver_crm_sales_details WHERE sls_order_dt IS NULL;

SELECT * from silver_crm_sales_details
WHERE sls_order_dt like '0000-00-00' or length(sls_order_dt) <> 10;


SELECT sls_ship_dt FROM silver_crm_sales_details WHERE sls_ship_dt IS NULL;

SELECT * from silver_crm_sales_details
WHERE sls_ship_dt like '0000-00-00' or length(sls_ship_dt) <> 10;

SELECT sls_due_dt FROM silver_crm_sales_details WHERE sls_due_dt IS NULL;

SELECT * from silver_crm_sales_details
WHERE sls_due_dt like '0000-00-00' or length(sls_due_dt) <> 10;




-- check for NULLS or Negative Numbers
-- Expectations = No Result

SELECT
sls_sales,
sls_quantity,
sls_price
FROM silver_crm_sales_details
WHERE 
sls_sales <> sls_price * sls_quantity 
OR sls_sales < 0 OR sls_sales IS NULL
OR sls_price < 0 OR sls_price IS NULL
OR sls_quantity < 0 OR sls_quantity IS NULL
ORDER BY sls_sales, sls_quantity, sls_price;

-- Table silver_erp_cust_az12
-- Check JOIN key
-- Expectations: No Result

SELECT
CASE 
	WHEN CID LIKE 'NAS%' THEN SUBSTR(CID, 4, length(CID))
	ELSE CID END AS CID,
BDATE,
GEN
FROM silver_erp_cust_az12
WHERE CASE WHEN CID LIKE 'NAS%' THEN substr(CID, 4, length(CID))
ELSE CID END NOT IN (SELECT DISTINCT cst_key FROM silver_crm_cust_info);

-- check for invalid birthdate
-- expectation: no result
-- if found invalid birthdate, change to null

SELECT DISTINCT BDATE from silver_erp_cust_az12
WHERE BDATE > NOW();

SELECT
CASE
	WHEN BDATE > NOW() THEN NULL
    ELSE BDATE END AS BDATE
FROM silver_erp_cust_az12
WHERE BDATE IS NULL;

-- Check for data standardization and consistency

SELECT DISTINCT GEN, LENGTH(GEN) from silver_erp_cust_az12;

-- TABLE: silver_erp_loc_a101
-- Standardize CID for joining table

SELECT CID FROM silver_erp_loc_a101;

-- Data standardization
SELECT DISTINCT CNTRY FROM silver_erp_loc_a101
ORDER BY CNTRY;

-- TABLE: silver_erp_px_cat_g1v2
-- Check for unwanted spaces
-- Expectations: No result

SELECT * FROM silver_erp_px_cat_g1v2
WHERE CAT <> TRIM(CAT) or SUBCAT <> TRIM(SUBCAT);

-- Check for data standardization

SELECT DISTINCT Maintenance FROM silver_erp_px_cat_g1v2;

SELECT DISTINCT CAT FROM silver_erp_px_cat_g1v2;

SELECT DISTINCT SUBCAT FROM silver_erp_px_cat_g1v2
