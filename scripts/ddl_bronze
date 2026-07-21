/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/

-- clean up existing tables

DROP TABLE IF EXISTS bronze_crm_cust_info;
DROP TABLE IF EXISTS bronze_crm_prd_info;
DROP TABLE IF EXISTS bronze_crm_sales_details;
DROP TABLE IF EXISTS bronze_erp_cust_az12;
DROP TABLE IF EXISTS bronze_erp_loc_a101;
DROP TABLE IF EXISTS bronze_erp_px_cat_g1v2;

-- start creating tables

CREATE TABLE bronze_crm_cust_info (
	cst_id int,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date NVARCHAR(50)
);

CREATE TABLE bronze_crm_prd_info (
	prd_id int,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(100),
	prd_cost int,
	prd_line NVARCHAR(50),
	prd_start_date date,
	prd_end_date date
);

CREATE TABLE bronze_crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int
);

CREATE TABLE bronze_erp_cust_az12 (
	CID NVARCHAR(50),
	BDATE date,
	GEN NVARCHAR(50)
);

CREATE TABLE bronze_erp_loc_a101 (
	CID NVARCHAR(50),
	CNTRY NVARCHAR(50)
);

CREATE TABLE bronze_erp_px_cat_g1v2 (
	ID NVARCHAR(50),
	CAT NVARCHAR(50),
	SUBCAT NVARCHAR(100),
	maintenance NVARCHAR(50)
);
