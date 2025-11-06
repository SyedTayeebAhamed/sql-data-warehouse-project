/*
===========================================================
 Project     : Data Warehouse Initialization
 Author      : Syed Tayeeb Ahamed
 Description : Creates the DataWareHouse database and sets up
               layered schemas for ETL processing (Bronze, Silver, Gold)
 Date        : 2025-11-06
===========================================================
*/

-- Switch to master to create the new database
USE master;

-- Create the DataWareHouse database
CREATE DATABASE DataWareHouse;

-- Switch context to the new database
USE DataWareHouse;
GO

-- Create Bronze schema for raw ingestion layer
CREATE SCHEMA bronze;
GO

-- Create Silver schema for cleaned and transformed data
CREATE SCHEMA silver;
GO

-- Create Gold schema for curated, analytics-ready data
CREATE SCHEMA gold;
GO
