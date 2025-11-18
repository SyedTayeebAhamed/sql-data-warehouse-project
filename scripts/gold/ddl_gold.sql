/*
====================================================================
View Definitions: Gold Layer – Dimensional Modeling
Author         : Syed Tayeeb Ahamed
Created On     : [Insert Date]
Description    : This script defines dimensional and fact views for
                 the gold layer of the data warehouse. It transforms
                 raw CRM and ERP data from the silver layer into
                 analytics-ready structures for reporting and BI.

--------------------------------------------------------------------
1. View: gold.dim_customers
   - Generates a surrogate key (customer_key) using ROW_NUMBER.
   - Combines CRM customer info with ERP demographic and location data.
   - Resolves gender using CRM first, then ERP fallback.
   - Includes country, marital status, birthdate, and creation date.

2. View: gold.dim_product
   - Generates a surrogate key (product_key) using ROW_NUMBER.
   - Joins CRM product info with ERP category metadata.
   - Filters out historical products using `prd_end_dt IS NULL`.
   - Includes category, subcategory, cost, product line, and start date.

3. View: gold.fact_sales
   - Builds a sales fact table by joining CRM sales details with
     gold-layer dimensions.
   - Includes order number, product and customer keys, order dates,
     shipping and due dates, quantity, price, and sales amount.

--------------------------------------------------------------------
Usage:
 - These views support star schema modeling for BI tools and dashboards.
 - Designed for performance and clarity in reporting layers.
 - Ensure silver layer views are refreshed before querying gold layer.

====================================================================
*/
CREATE VIEW gold.dim_customers AS
SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,         -- Surrogate key
    ci.cst_id AS customer_id,                                    -- CRM customer ID
    ci.cst_key AS customer_number,                               -- CRM customer number
    ci.cst_firstname AS first_name,                              -- First name
    ci.cst_lastname AS last_name,                                -- Last name
    la.CNTRY AS country,                                         -- Country from ERP location
    ci.cst_material_status AS marital_status,                    -- Marital status
    CASE                                                         -- Gender resolution logic
        WHEN ci.cst_gndr <> 'N/A' THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'N/A')
    END AS gender,
    ca.BDATE AS birthdate,                                       -- Birthdate from ERP
    ci.cst_create_date AS create_date                            -- CRM creation date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_CUST_AZ12 ca ON ci.cst_key = ca.CID
LEFT JOIN silver.erp_LOC_A101 la ON ci.cst_key = la.CID;
GO

-- ================================================================
-- View: gold.dim_product
-- Description:
--   - Creates a product dimension with a surrogate key.
--   - Joins CRM product info with ERP category metadata.
--   - Filters out historical products using prd_end_dt IS NULL.
--   - Includes category, subcategory, cost, product line, and start date.
-- ================================================================
CREATE VIEW gold.dim_product AS
SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn.prd_id AS product_id,                                                  -- CRM product ID
    pn.prd_key AS product_number,                                             -- CRM product number
    pn.prd_nm AS product_name,                                                -- Product name
    pn.cat_id AS category_id,                                                 -- Category ID
    pc.CAT AS category,                                                       -- Category name
    pc.SUBCAT AS subcategory,                                                 -- Subcategory
    pc.maintenance,                                                           -- Maintenance flag
    pn.prd_cost AS cost,                                                      -- Product cost
    pn.prd_line AS product_line,                                              -- Product line
    pn.prd_start_dt AS start_date                                             -- Product start date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_PX_CAT_G1V2 pc ON pn.cat_id = pc.ID
WHERE prd_end_dt IS NULL; -- Filter out historical products
GO

-- ================================================================
-- View: gold.fact_sales
-- Description:
--   - Creates a sales fact table by joining CRM sales details
--     with gold-layer product and customer dimensions.
--   - Includes order number, product and customer keys, order dates,
--     shipping and due dates, quantity, price, and sales amount.
-- ================================================================
CREATE VIEW gold.fact_sales AS
SELECT
    sd.sls_ord_num AS order_number,       -- Sales order number
    pr.product_key,                       -- Foreign key to dim_product
    cu.customer_key,                      -- Foreign key to dim_customers
    sd.sls_order_dt AS order_date,        -- Order date
    sd.sls_ship_dt AS shipping_date,      -- Shipping date
    sd.sls_due_dt AS due_date,            -- Due date
    sd.sls_sales AS sales_amount,         -- Total sales amount
    sd.sls_quantity AS quanity,           -- Quantity sold
    sd.sls_price AS price                 -- Unit price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id;
GO
