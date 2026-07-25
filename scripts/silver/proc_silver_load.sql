/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    CALL Silver.load_silver;
===============================================================================
*/

DELIMITER //

CREATE PROCEDURE proc_load_silver ()
BEGIN
    SELECT '===========================================' AS Status;
    SELECT '   STARTING SILVER LAYER ETL PIPELINE     ' AS Status;
    SELECT '===========================================' AS Status;


    -- =========================================================================
    -- 1. Load silver_crm_cust_info
    -- =========================================================================
    SELECT '>> Truncating table: silver_crm_cust_info...' AS Status;
    TRUNCATE TABLE silver_crm_cust_info;

    SELECT '>> Inserting data into: silver_crm_cust_info...' AS Status;
    INSERT INTO silver_crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_marital_status,
        cst_gndr,
        cst_create_date
    )
    SELECT 
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
             WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
             ELSE 'n/a'
        END AS cst_marital_status,
        CASE WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
             WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
             ELSE 'n/a'
        END AS cst_gndr,
        cst_create_date 
    FROM (
        SELECT *,
               ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
        FROM bronze_crm_cust_info 
        WHERE cst_id IS NOT NULL
    ) t
    WHERE flag_last = 1;

    SELECT CONCAT('>> Completed silver_crm_cust_info (Rows inserted: ', ROW_COUNT(), ')') AS Status;


    -- =========================================================================
    -- 2. Load silver_crm_prd_info
    -- =========================================================================
    SELECT '>> Truncating table: silver_crm_prd_info...' AS Status;
    TRUNCATE TABLE silver_crm_prd_info;

    SELECT '>> Inserting data into: silver_crm_prd_info...' AS Status;
    INSERT INTO silver_crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    SELECT
        prd_id,
        REPLACE(SUBSTR(prd_key, 1, 5), '-', '_') AS cat_id,
        SUBSTR(prd_key, 7) AS prd_key,
        prd_nm,
        COALESCE(prd_cost, 0) AS prd_cost, 
        CASE WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
             WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
             WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
             WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
             ELSE 'n/a' 
        END AS prd_line,
        prd_start_dt,
        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL 1 DAY AS prd_end_dt
    FROM bronze_crm_prd_info;

    SELECT CONCAT('>> Completed silver_crm_prd_info (Rows inserted: ', ROW_COUNT(), ')') AS Status;


    -- =========================================================================
    -- 3. Load silver_crm_sales_details
    -- =========================================================================
    SELECT '>> Truncating table: silver_crm_sales_details...' AS Status;
    TRUNCATE TABLE silver_crm_sales_details;

    SELECT '>> Inserting data into: silver_crm_sales_details...' AS Status;
    INSERT INTO silver_crm_sales_details (
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        sls_order_dt,
        sls_ship_dt,
        sls_due_dt,
        sls_sales,
        sls_quantity,
        sls_price
    )
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,
        CASE 
            WHEN sls_order_dt LIKE '0000-00-00' OR LENGTH(sls_order_dt) <> 10 OR sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt THEN NULL
            ELSE sls_order_dt 
        END AS sls_order_dt,
        CASE 
            WHEN sls_ship_dt LIKE '0000-00-00' OR LENGTH(sls_ship_dt) <> 10 OR sls_ship_dt > sls_due_dt THEN NULL
            ELSE sls_ship_dt 
        END AS sls_ship_dt,
        CASE 
            WHEN sls_due_dt LIKE '0000-00-00' OR LENGTH(sls_due_dt) <> 10 OR sls_due_dt < sls_order_dt OR sls_due_dt < sls_ship_dt THEN NULL
            ELSE sls_due_dt 
        END AS sls_due_dt,
        CASE 
            WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales <> sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
            ELSE sls_sales 
        END AS sls_sales,
        sls_quantity,
        CASE 
            WHEN sls_price IS NULL OR sls_price <= 0 THEN ROUND(ABS(sls_sales) / NULLIF(sls_quantity, 0))
            ELSE sls_price 
        END AS sls_price
    FROM bronze_crm_sales_details;

    SELECT CONCAT('>> Completed silver_crm_sales_details (Rows inserted: ', ROW_COUNT(), ')') AS Status;


    -- =========================================================================
    -- 4. Load silver_erp_cust_az12
    -- =========================================================================
    SELECT '>> Truncating table: silver_erp_cust_az12...' AS Status;
    TRUNCATE TABLE silver_erp_cust_az12;

    SELECT '>> Inserting data into: silver_erp_cust_az12...' AS Status;
    INSERT INTO silver_erp_cust_az12(
        CID,
        BDATE,
        GEN
    )
    SELECT
        CASE 
            WHEN CID LIKE 'NAS%' THEN SUBSTR(CID, 4)
            ELSE CID 
        END AS CID,
        CASE
            WHEN BDATE > NOW() THEN NULL
            ELSE BDATE 
        END AS BDATE,
        CASE 
            WHEN UPPER(TRIM(GEN)) IN ('M', 'MALE') THEN 'Male'
            WHEN UPPER(TRIM(GEN)) IN ('F', 'FEMALE') THEN 'Female'
            ELSE 'n/a' 
        END AS GEN
    FROM bronze_erp_cust_az12;

    SELECT CONCAT('>> Completed silver_erp_cust_az12 (Rows inserted: ', ROW_COUNT(), ')') AS Status;


    -- =========================================================================
    -- 5. Load silver_erp_loc_a101
    -- =========================================================================
    SELECT '>> Truncating table: silver_erp_loc_a101...' AS Status;
    TRUNCATE TABLE silver_erp_loc_a101;

    SELECT '>> Inserting data into: silver_erp_loc_a101...' AS Status;
    INSERT INTO silver_erp_loc_a101 (
        CID,
        CNTRY
    )
    SELECT
        REPLACE(CID, '-', '') AS CID,
        CASE
            WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
            WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
            WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'
            ELSE TRIM(CNTRY)
        END AS CNTRY
    FROM bronze_erp_loc_a101;

    SELECT CONCAT('>> Completed silver_erp_loc_a101 (Rows inserted: ', ROW_COUNT(), ')') AS Status;


    -- =========================================================================
    -- 6. Load silver_erp_px_cat_g1v2
    -- =========================================================================
    SELECT '>> Truncating table: silver_erp_px_cat_g1v2...' AS Status;
    TRUNCATE TABLE silver_erp_px_cat_g1v2;

    SELECT '>> Inserting data into: silver_erp_px_cat_g1v2...' AS Status;
    INSERT INTO silver_erp_px_cat_g1v2 (
        ID,
        CAT,
        SUBCAT,
        Maintenance
    )
    SELECT
        ID,
        CAT,
        SUBCAT,
        Maintenance
    FROM bronze_erp_px_cat_g1v2;

    SELECT CONCAT('>> Completed silver_erp_px_cat_g1v2 (Rows inserted: ', ROW_COUNT(), ')') AS Status;


    SELECT '===========================================' AS Status;
    SELECT '   SILVER LAYER ETL COMPLETED SUCCESSFULLY  ' AS Status;
    SELECT '===========================================' AS Status;
END //

DELIMITER ;

