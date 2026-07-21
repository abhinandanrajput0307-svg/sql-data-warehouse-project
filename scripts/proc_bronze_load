/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

DELIMITER //

DROP PROCEDURE IF EXISTS load_bronze //

CREATE PROCEDURE load_bronze()
BEGIN
    -- Declare tracking variables
    DECLARE v_start_time DATETIME;
    DECLARE v_end_time DATETIME;
    DECLARE v_batch_start_time DATETIME;
    DECLARE v_batch_end_time DATETIME;
    
    -- Declare error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 
            @sqlstate = RETURNED_SQLSTATE, 
            @errno = MYSQL_ERRNO, 
            @text = MESSAGE_TEXT;
            
        SELECT '==========================================' AS Message;
        SELECT 'ERROR OCCURRED DURING LOADING BRONZE LAYER' AS Message;
        SELECT CONCAT('Error Number: ', @errno) AS Message;
        SELECT CONCAT('Error State: ', @sqlstate) AS Message;
        SELECT CONCAT('Error Message: ', @text) AS Message;
        SELECT '==========================================' AS Message;
    END;

    SET v_batch_start_time = NOW();
    
    SELECT '================================================' AS Status;
    SELECT 'Loading Bronze Layer' AS Status;
    SELECT '================================================' AS Status;

    SELECT '------------------------------------------------' AS Status;
    SELECT 'Loading CRM Tables' AS Status;
    SELECT '------------------------------------------------' AS Status;

    -- 1. bronze_crm_cust_info
    SET v_start_time = NOW();
    SELECT '>> Truncating Table: bronze_crm_cust_info' AS Status;
    TRUNCATE TABLE bronze_crm_cust_info;

    SELECT '>> Inserting Data Into: bronze_crm_cust_info' AS Status;
    LOAD DATA INFILE 'C:/sql/dwh_project/datasets/source_crm/cust_info.csv'
    INTO TABLE bronze_crm_cust_info
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

    SET v_end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS Status;
    SELECT '>> -------------' AS Status;

    -- 2. bronze_crm_prd_info
    SET v_start_time = NOW();
    SELECT '>> Truncating Table: bronze_crm_prd_info' AS Status;
    TRUNCATE TABLE bronze_crm_prd_info;

    SELECT '>> Inserting Data Into: bronze_crm_prd_info' AS Status;
    LOAD DATA INFILE 'C:/sql/dwh_project/datasets/source_crm/prd_info.csv'
    INTO TABLE bronze_crm_prd_info
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

    SET v_end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS Status;
    SELECT '>> -------------' AS Status;

    -- 3. bronze_crm_sales_details
    SET v_start_time = NOW();
    SELECT '>> Truncating Table: bronze_crm_sales_details' AS Status;
    TRUNCATE TABLE bronze_crm_sales_details;

    SELECT '>> Inserting Data Into: bronze_crm_sales_details' AS Status;
    LOAD DATA INFILE 'C:/sql/dwh_project/datasets/source_crm/sales_details.csv'
    INTO TABLE bronze_crm_sales_details
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

    SET v_end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS Status;
    SELECT '>> -------------' AS Status;

    SELECT '------------------------------------------------' AS Status;
    SELECT 'Loading ERP Tables' AS Status;
    SELECT '------------------------------------------------' AS Status;

    -- 4. bronze_erp_loc_a101
    SET v_start_time = NOW();
    SELECT '>> Truncating Table: bronze_erp_loc_a101' AS Status;
    TRUNCATE TABLE bronze_erp_loc_a101;

    SELECT '>> Inserting Data Into: bronze_erp_loc_a101' AS Status;
    LOAD DATA INFILE 'C:/sql/dwh_project/datasets/source_erp/loc_a101.csv'
    INTO TABLE bronze_erp_loc_a101
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

    SET v_end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS Status;
    SELECT '>> -------------' AS Status;

    -- 5. bronze_erp_cust_az12
    SET v_start_time = NOW();
    SELECT '>> Truncating Table: bronze_erp_cust_az12' AS Status;
    TRUNCATE TABLE bronze_erp_cust_az12;

    SELECT '>> Inserting Data Into: bronze_erp_cust_az12' AS Status;
    LOAD DATA INFILE 'C:/sql/dwh_project/datasets/source_erp/cust_az12.csv'
    INTO TABLE bronze_erp_cust_az12
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

    SET v_end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS Status;
    SELECT '>> -------------' AS Status;

    -- 6. bronze_erp_px_cat_g1v2
    SET v_start_time = NOW();
    SELECT '>> Truncating Table: bronze_erp_px_cat_g1v2' AS Status;
    TRUNCATE TABLE bronze_erp_px_cat_g1v2;

    SELECT '>> Inserting Data Into: bronze_erp_px_cat_g1v2' AS Status;
    LOAD DATA INFILE 'C:/sql/dwh_project/datasets/source_erp/px_cat_g1v2.csv'
    INTO TABLE bronze_erp_px_cat_g1v2
    FIELDS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES;

    SET v_end_time = NOW();
    SELECT CONCAT('>> Load Duration: ', TIMESTAMPDIFF(SECOND, v_start_time, v_end_time), ' seconds') AS Status;
    SELECT '>> -------------' AS Status;

    -- Execution Summary
    SET v_batch_end_time = NOW();
    SELECT '==========================================' AS Status;
    SELECT 'Loading Bronze Layer is Completed' AS Status;
    SELECT CONCAT('   - Total Load Duration: ', TIMESTAMPDIFF(SECOND, v_batch_start_time, v_batch_end_time), ' seconds') AS Status;
    SELECT '==========================================' AS Status;

END //

DELIMITER ;
