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



