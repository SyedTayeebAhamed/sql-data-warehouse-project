/*
===================================================================================
DDL Script : Create Bronze Table
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing table 
  if they already exist.
  Run this script to re-define the DDL structure of 'bronze' tables
===================================================================================
*/
if OBJECT_ID('bronze.crm_cust_info','U') is not null 
drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
cst_id int,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_material_status varchar(50),
cst_gndr varchar(50),
cst_create date
);
if OBJECT_ID('bronze.crm_prd_info','U') is not null 
drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line nvarchar(5),
prd_start_dt date,
prd_end_dt date
);
if OBJECT_ID('bronze.crm_sales_details','U') is not null 
drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
sls_ord_num varchar(7),
sls_prd_key varchar(10),
sls_cust_id int,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_sales int,
sls_quantity int,
sls_price int
);
if OBJECT_ID('bronze.erp_CUST_AZ12','U') is not null 
drop table bronze.erp_CUST_AZ12;
create table bronze.erp_CUST_AZ12(
CID varchar(13),
BDATE date,
GEN VARCHAR(10) NOT NULL  CHECK (GEN IN ('Male', 'Female', 'Other'))
);

if OBJECT_ID('bronze.erp_LOC_A101','U') is not null 
drop table bronze.erp_LOC_A101;
create table bronze.erp_LOC_A101(
CID varchar(13),
CNTRY varchar(50)
);
if OBJECT_ID('bronze.erp_PX_CAT_G1V2','U') is not null 
drop table bronze.erp_PX_CAT_G1V2;
create table bronze.erp_PX_CAT_G1V2(
ID varchar(5),
CAT varchar(50),
SUBCAT varchar(50),
MAINTENANCE varchar (3) not null check (MAINTENANCE IN ('Yes','No'))
);


go

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @Start_time DATETIME, @End_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

    BEGIN TRY
        SET @batch_start_time = GETDATE();

        PRINT('==============================================');
        PRINT('Starting Full Load into Bronze Layer');
        PRINT('==============================================');

        -- CRM_CUST_INFO
        SET @Start_time = GETDATE();
        PRINT('----------------------------------------------');
        PRINT('Truncating and Loading CRM_CUST_INFO');
        PRINT('----------------------------------------------');
        TRUNCATE TABLE [bronze].[crm_cust_info];
        PRINT('Table [bronze].[crm_cust_info] truncated');
        BULK INSERT [bronze].[crm_cust_info]
        FROM 'C:\Users\ssyed\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @End_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' seconds';
        PRINT('Data loaded into [bronze].[crm_cust_info]');

        -- CRM_PRD_INFO
        SET @Start_time = GETDATE();
        PRINT('----------------------------------------------');
        PRINT('Truncating and Loading CRM_PRD_INFO');
        PRINT('----------------------------------------------');
        TRUNCATE TABLE [bronze].[crm_prd_info];
        PRINT('Table [bronze].[crm_prd_info] truncated');
        BULK INSERT [bronze].[crm_prd_info]
        FROM 'C:\Users\ssyed\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @End_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' seconds';
        PRINT('Data loaded into [bronze].[crm_prd_info]');

        -- CRM_SALES_DETAILS
        SET @Start_time = GETDATE();
        PRINT('----------------------------------------------');
        PRINT('Truncating and Loading CRM_SALES_DETAILS');
        PRINT('----------------------------------------------');
        TRUNCATE TABLE [bronze].[crm_sales_details];
        PRINT('Table [bronze].[crm_sales_details] truncated');
        BULK INSERT [bronze].[crm_sales_details]
        FROM 'C:\Users\ssyed\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @End_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' seconds';
        PRINT('Data loaded into [bronze].[crm_sales_details]');

        -- ERP_CUST_AZ12
        PRINT('==============================================');
        PRINT('Loading ERP Tables');
        PRINT('==============================================');
        SET @Start_time = GETDATE();
        PRINT('----------------------------------------------');
        PRINT('Truncating and Loading ERP_CUST_AZ12');
        PRINT('----------------------------------------------');
        TRUNCATE TABLE [bronze].[erp_CUST_AZ12];
        PRINT('Table [bronze].[erp_CUST_AZ12] truncated');
        BULK INSERT [bronze].[erp_CUST_AZ12]
        FROM 'C:\Users\ssyed\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @End_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' seconds';
        PRINT('Data loaded into [bronze].[erp_CUST_AZ12]');

        -- ERP_LOC_A101
        SET @Start_time = GETDATE();
        PRINT('----------------------------------------------');
        PRINT('Truncating and Loading ERP_LOC_A101');
        PRINT('----------------------------------------------');
        TRUNCATE TABLE [bronze].[erp_LOC_A101];
        PRINT('Table [bronze].[erp_LOC_A101] truncated');
        BULK INSERT [bronze].[erp_LOC_A101]
        FROM 'C:\Users\ssyed\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @End_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' seconds';
        PRINT('Data loaded into [bronze].[erp_LOC_A101]');

        -- ERP_PX_CAT_G1V2
        SET @Start_time = GETDATE();
        PRINT('----------------------------------------------');
        PRINT('Truncating and Loading ERP_PX_CAT_G1V2');
        PRINT('----------------------------------------------');
        TRUNCATE TABLE [bronze].[erp_PX_CAT_G1V2];
        PRINT('Table [bronze].[erp_PX_CAT_G1V2] truncated');
        BULK INSERT [bronze].[erp_PX_CAT_G1V2]
        FROM 'C:\Users\ssyed\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @End_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @Start_time, @End_time) AS NVARCHAR) + ' seconds';
        PRINT('Data loaded into [bronze].[erp_PX_CAT_G1V2]');

        -- Completion
        PRINT('==============================================');
        PRINT('Bronze Layer Load Completed Successfully');
        PRINT('==============================================');
        SET @batch_end_time = GETDATE();
        PRINT '>> Batch Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR) + ' seconds';

    END TRY
    BEGIN CATCH
        PRINT '=======================================================';
        PRINT 'Error occurred during loading bronze layer';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10));
        PRINT '=======================================================';
    END CATCH
END
