/********************************************************************************************
-- Script Name   : Silver Layer Table Initialization
-- Author        : Syed Tayeeb Ahamed
-- Date Created  : 2025-11-11
-- Description   : This script drops and recreates all Silver Layer tables used in the 
                   Data Warehouse. Each table includes metadata tracking via dwh_create_date.
                   Constraints and data types are standardized for downstream processing.
-- Target Schema : silver
-- Tables Included:
    - crm_cust_info
    - crm_prd_info
    - crm_sales_details
    - erp_CUST_AZ12
    - erp_LOC_A101
    - erp_PX_CAT_G1V2
********************************************************************************************/

 if OBJECT_ID('silver.crm_cust_info','U') is not null 
drop table silver.crm_cust_info;
go
create table silver.crm_cust_info(
cst_id int,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_material_status varchar(50),
cst_gndr varchar(50),
cst_create date,
dwh_create_date datetime2 default getdate() --metadata
);
if OBJECT_ID('silver.crm_prd_info','U') is not null 
drop table silver.crm_prd_info;
create table silver.crm_prd_info(
prd_id int,
cat_id varchar(50),
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line nvarchar(50),
prd_start_dt date,
prd_end_dt date,
dwh_create_date datetime2 default getdate()
);
if OBJECT_ID('silver.crm_sales_details','U') is not null 
drop table silver.crm_sales_details;
create table silver.crm_sales_details(
sls_ord_num varchar(7),
sls_prd_key varchar(10),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int,
dwh_create_date datetime2 default getdate()
);
if OBJECT_ID('silver.erp_CUST_AZ12','U') is not null 
drop table silver.erp_CUST_AZ12;
create table silver.erp_CUST_AZ12(
CID varchar(13),
BDATE date,
GEN VARCHAR(10) NOT NULL  CHECK (GEN IN ('Male', 'Female', 'N/A')),
dwh_create_date datetime2 default getdate()
);

if OBJECT_ID('silver.erp_LOC_A101','U') is not null 
drop table silver.erp_LOC_A101;
create table silver.erp_LOC_A101(
CID varchar(13),
CNTRY varchar(50),
dwh_create_date datetime2 default getdate()
);
if OBJECT_ID('silver.erp_PX_CAT_G1V2','U') is not null 
drop table silver.erp_PX_CAT_G1V2;
create table silver.erp_PX_CAT_G1V2(
ID varchar(5),
CAT varchar(50),
SUBCAT varchar(50),
MAINTENANCE varchar (3) not null check (MAINTENANCE IN ('Yes','No')),
dwh_create_date datetime2 default getdate()
);
