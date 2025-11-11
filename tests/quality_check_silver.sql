/********************************************************************************************
-- Script Name   : Bronze and Silver Layer Quality Checks
-- Author        : Syed Tayeeb Ahamed
-- Description   : Validates data integrity, standardization, and consistency across Bronze and Silver layers.
-- Tables Checked:
    - bronze.crm_cust_info
    - bronze.crm_sales_details
    - bronze.erp_PX_CAT_G1V2
    - silver.crm_prd_info
    - silver.crm_cust_info
    - silver.erp_CUST_AZ12
********************************************************************************************/

---------------------------------------------------------------
-- CRM_CUST_INFO (Bronze)
---------------------------------------------------------------

-- Check for nulls or duplicate primary keys
SELECT cst_id, COUNT(*) AS duplicate_count
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces in first name
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname <> TRIM(cst_firstname);

-- Check distinct values for marital status
SELECT DISTINCT cst_material_status
FROM bronze.crm_cust_info;

-- Check distinct values for gender
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;


---------------------------------------------------------------
-- CRM_PRD_INFO (Silver)
---------------------------------------------------------------

-- Check for negative or null product cost
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check distinct values for product line
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check for invalid date order
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt > prd_end_dt;


---------------------------------------------------------------
-- CRM_SALES_DETAILS (Bronze)
---------------------------------------------------------------

-- Check for orphan customer references
SELECT *
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (
    SELECT cst_id FROM silver.crm_cust_info
);

-- Check for invalid order dates
SELECT NULLIF(sls_order_dt, 0) AS sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) <> 8;

-- Check for inconsistent date sequences
SELECT *
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;


---------------------------------------------------------------
-- ERP_CUST_AZ12 (Silver)
---------------------------------------------------------------

-- Check for future birthdates
SELECT DISTINCT BDATE
FROM silver.erp_CUST_AZ12
WHERE BDATE > GETDATE();

-- Check distinct gender values
SELECT DISTINCT GEN
FROM silver.erp_CUST_AZ12;


---------------------------------------------------------------
-- ERP_PX_CAT_G1V2 (Bronze)
---------------------------------------------------------------

-- Check for unwanted spaces in CAT
SELECT *
FROM bronze.erp_PX_CAT_G1V2
WHERE CAT <> TRIM(CAT);

-- Check for unwanted spaces in SUBCAT and MAINTENANCE
SELECT *
FROM bronze.erp_PX_CAT_G1V2
WHERE SUBCAT <> TRIM(SUBCAT) OR MAINTENANCE <> TRIM(MAINTENANCE);
