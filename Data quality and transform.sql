SELECT * FROM bm_stores LIMIT 10;
SELECT * FROM bm_skus LIMIT 10;
SELECT * FROM bm_customers LIMIT 10;
SELECT * FROM bm_inventory LIMIT 10;
SELECT * FROM bm_sales LIMIT 10;



-- Data Quality check and validation:
SELECT 'bm_stores' AS table_name, COUNT(*) AS row_count
FROM bm_stores

UNION ALL

SELECT 'bm_skus', COUNT(*)
FROM bm_skus

UNION ALL

SELECT 'bm_customers', COUNT(*)
FROM bm_customers

UNION ALL

SELECT 'bm_inventory', COUNT(*)
FROM bm_inventory

UNION ALL

SELECT 'bm_sales', COUNT(*)
FROM bm_sales;

-- Primary key validation:
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT store_id) AS unique_store_ids
FROM bm_stores;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT sku_id) AS unique_sku_ids
FROM bm_skus;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT cust_id) AS unique_customer_ids
FROM bm_customers;

-- Inventory grain validation:
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (store_id, sku_id, snapshot_date)) AS unique_inventory_keys
FROM bm_inventory;

-- NULL validation:

-- Stores:
SELECT
    COUNT(*) FILTER (WHERE store_id IS NULL) AS store_id_nulls,
    COUNT(*) FILTER (WHERE store_name IS NULL) AS store_name_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE store_type IS NULL) AS store_type_nulls
FROM bm_stores;

-- SKU:
SELECT
    COUNT(*) FILTER (WHERE sku_id IS NULL) AS sku_id_nulls,
    COUNT(*) FILTER (WHERE sku_name IS NULL) AS sku_name_nulls,
    COUNT(*) FILTER (WHERE category IS NULL) AS category_nulls,
    COUNT(*) FILTER (WHERE subcategory IS NULL) AS subcategory_nulls,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_nulls,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS cost_price_nulls,
    COUNT(*) FILTER (WHERE brand IS NULL) AS brand_nulls
FROM bm_skus;

-- Customers:
SELECT
    COUNT(*) FILTER (WHERE cust_id IS NULL) AS cust_id_nulls,
    COUNT(*) FILTER (WHERE age IS NULL) AS age_nulls,
    COUNT(*) FILTER (WHERE gender IS NULL) AS gender_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE loyalty_segment IS NULL) AS loyalty_segment_nulls,
    COUNT(*) FILTER (WHERE preferred_channel IS NULL) AS preferred_channel_nulls,
    COUNT(*) FILTER (WHERE registration_date IS NULL) AS registration_date_nulls
FROM bm_customers;


-- Sales:
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE date IS NULL) AS date_nulls,
    COUNT(*) FILTER (WHERE store_id IS NULL) AS store_id_nulls,
    COUNT(*) FILTER (WHERE sku_id IS NULL) AS sku_id_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_nulls,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_nulls,
    COUNT(*) FILTER (WHERE total_value IS NULL) AS total_value_nulls,
    COUNT(*) FILTER (WHERE channel IS NULL) AS channel_nulls,
    COUNT(*) FILTER (WHERE discount_pct IS NULL) AS discount_pct_nulls
FROM bm_sales;


-- Foreign key Intergrity check:
SELECT COUNT(*) AS orphan_store_records
FROM bm_sales s
LEFT JOIN bm_stores st
    ON s.store_id = st.store_id
WHERE st.store_id IS NULL;


SELECT COUNT(*) AS orphan_sku_records
FROM bm_sales s
LEFT JOIN bm_skus sk
    ON s.sku_id = sk.sku_id
WHERE sk.sku_id IS NULL;

SELECT COUNT(*) AS orphan_customer_records
FROM bm_sales s
LEFT JOIN bm_customers c
    ON s.customer_id = c.cust_id
WHERE s.customer_id IS NOT NULL
  AND c.cust_id IS NULL;


-- Duplicates:
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT (
        date,
        store_id,
        sku_id,
        customer_id,
        quantity,
        unit_price,
        total_value,
        channel,
        discount_pct
    )) AS unique_sales_records
FROM bm_sales;


SELECT
    date,
    store_id,
    sku_id,
    customer_id,
    quantity,
    unit_price,
    total_value,
    channel,
    discount_pct,
    COUNT(*) AS duplicate_count
FROM bm_sales
GROUP BY
    date,
    store_id,
    sku_id,
    customer_id,
    quantity,
    unit_price,
    total_value,
    channel,
    discount_pct
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 20; 


-- Sales Value / Discount Validation:
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (
        WHERE ABS(
            (quantity * unit_price) - total_value
        ) <= 0.01
    ) AS matches_gross_value,
    COUNT(*) FILTER (
        WHERE ABS(
            (quantity * unit_price * (1 - discount_pct / 100.0))
            - total_value
        ) <= 0.01
    ) AS matches_discounted_value
FROM bm_sales;

-- Determine What unit_price Represents:
SELECT
    COUNT(*) AS total_sales,
    COUNT(*) FILTER (
        WHERE s.unit_price = k.unit_price
    ) AS exact_price_matches,
    COUNT(*) FILTER (
        WHERE s.unit_price <> k.unit_price
    ) AS price_differences
FROM bm_sales s
JOIN bm_skus k
    ON s.sku_id = k.sku_id;
-----------------------------------------
SELECT
    discount_pct,
    COUNT(*) AS sales_rows,
    COUNT(*) FILTER (
        WHERE s.unit_price = k.unit_price
    ) AS price_matches,
    COUNT(*) FILTER (
        WHERE s.unit_price <> k.unit_price
    ) AS price_differences
FROM bm_sales s
JOIN bm_skus k
    ON s.sku_id = k.sku_id
GROUP BY discount_pct
ORDER BY discount_pct;


-- Business Rule:
SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantity,
    COUNT(*) FILTER (WHERE unit_price < 0) AS invalid_unit_price,
    COUNT(*) FILTER (WHERE total_value < 0) AS invalid_total_value,
    COUNT(*) FILTER (
        WHERE discount_pct < 0 OR discount_pct > 100
    ) AS invalid_discount
FROM bm_sales;


SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE unit_price < 0) AS negative_unit_price,
    COUNT(*) FILTER (WHERE cost_price < 0) AS negative_cost_price,
    COUNT(*) FILTER (WHERE unit_price = 0) AS zero_unit_price,
    COUNT(*) FILTER (WHERE cost_price = 0) AS zero_cost_price
FROM bm_skus;


SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE stock_on_hand < 0) AS negative_stock,
    COUNT(*) FILTER (WHERE reorder_point < 0) AS negative_reorder_point,
    COUNT(*) FILTER (WHERE safety_stock < 0) AS negative_safety_stock
FROM bm_inventory;


-- Date Coverage:
SELECT
    MIN(date) AS first_sales_date,
    MAX(date) AS last_sales_date,
    COUNT(DISTINCT date) AS sales_days
FROM bm_sales;

SELECT
    MIN(snapshot_date) AS first_snapshot,
    MAX(snapshot_date) AS last_snapshot,
    COUNT(DISTINCT snapshot_date) AS snapshot_days
FROM bm_inventory;

SELECT
    MIN(registration_date) AS first_registration,
    MAX(registration_date) AS last_registration
FROM bm_customers;


-- Data Preparation and Transformation:
------------------------------------------


CREATE OR REPLACE VIEW vw_dim_date AS
SELECT
    d::date AS date,
    EXTRACT(YEAR FROM d)::int AS year,
    EXTRACT(QUARTER FROM d)::int AS quarter,
    EXTRACT(MONTH FROM d)::int AS month_number,
    TO_CHAR(d, 'Month') AS month_name,
    EXTRACT(WEEK FROM d)::int AS week_number,
    EXTRACT(DOW FROM d)::int AS day_of_week,
    TO_CHAR(d, 'Day') AS day_name,
    CASE
        WHEN EXTRACT(DOW FROM d) IN (0, 6) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM generate_series(
    '2021-01-01'::date,
    '2025-10-31'::date,
    INTERVAL '1 day'
) AS d;

------------------------------------------

-- Create view SAles_enriched:

CREATE OR REPLACE VIEW vw_sales_enriched AS
SELECT
    s.date,
    s.store_id,
    st.store_name,
    st.city AS store_city,
    st.store_type,

    s.sku_id,
    sk.sku_name,
    sk.category,
    sk.subcategory,
    sk.brand,

    s.customer_id,
    CASE
        WHEN s.customer_id IS NULL THEN 'Unidentified Customer'
        ELSE 'Identified Customer'
    END AS customer_status,

    c.loyalty_segment,
    c.preferred_channel,

    s.channel,
    s.quantity,
    sk.unit_price AS list_price,
    s.unit_price AS selling_price,
    s.discount_pct,
    s.total_value AS net_sales,

    -- Value before transaction discount
    s.quantity * sk.unit_price AS gross_list_value,

    -- Value given up through discounting
    (s.quantity * sk.unit_price) - s.total_value AS discount_amount,

    -- Product cost
    s.quantity * sk.cost_price AS product_cost,

    -- Gross profit
    s.total_value - (s.quantity * sk.cost_price) AS gross_profit,

    -- Gross margin %
    CASE
        WHEN s.total_value <> 0 THEN
            (
                (s.total_value - (s.quantity * sk.cost_price))
                / s.total_value
            ) * 100
        ELSE NULL
    END AS gross_margin_pct
FROM bm_sales s
LEFT JOIN bm_stores st
    ON s.store_id = st.store_id
LEFT JOIN bm_skus sk
    ON s.sku_id = sk.sku_id
LEFT JOIN bm_customers c
    ON s.customer_id = c.cust_id;

/*
Original sales
      +
Store attributes
      +
SKU attributes
      +
Customer attributes
      +
Profitability metrics
      ↓
Analytical sales layer
*/
---------------------------------------

-- Create view Inventory Risk:
CREATE OR REPLACE VIEW vw_inventory_risk AS
SELECT
    i.snapshot_date,
    i.store_id,
    st.store_name,
    st.city AS store_city,
    st.store_type,

    i.sku_id,
    sk.sku_name,
    sk.category,
    sk.subcategory,
    sk.brand,

    i.stock_on_hand,
    i.reorder_point,
    i.safety_stock,
    i.last_restock_date,

    CASE
        WHEN i.stock_on_hand < i.safety_stock
            THEN 'Below Safety Stock'
        WHEN i.stock_on_hand < i.reorder_point
            THEN 'Below Reorder Point'
        ELSE 'Normal'
    END AS inventory_status
FROM bm_inventory i
LEFT JOIN bm_stores st
    ON i.store_id = st.store_id
LEFT JOIN bm_skus sk
    ON i.sku_id = sk.sku_id;

-- stock < safety_stock -- 
---------------------------------------

-- KPI and metrics baseline:
SELECT
    COUNT(*) AS sales_records,
    SUM(quantity) AS units_sold,
    SUM(net_sales) AS net_sales,
    SUM(gross_list_value) AS gross_list_value,
    SUM(discount_amount) AS discount_amount,
    SUM(product_cost) AS product_cost,
    SUM(gross_profit) AS gross_profit,

    CASE
        WHEN SUM(net_sales) <> 0
        THEN SUM(gross_profit) / SUM(net_sales) * 100
        ELSE 0
    END AS gross_margin_pct,

    CASE
        WHEN SUM(gross_list_value) <> 0
        THEN SUM(discount_amount) / SUM(gross_list_value) * 100
        ELSE 0
    END AS discount_rate,

    CASE
        WHEN SUM(quantity) <> 0
        THEN SUM(net_sales) / SUM(quantity)
        ELSE 0
    END AS avg_selling_price
FROM vw_sales_enriched;

-- Customer baseline:
SELECT
    COUNT(*) AS sales_records,
    COUNT(*) FILTER (
        WHERE customer_id IS NOT NULL
    ) AS identified_sales_records,
    COUNT(*) FILTER (
        WHERE customer_id IS NULL
    ) AS unidentified_sales_records,

    COUNT(DISTINCT customer_id) AS identified_customers,

    ROUND(
        COUNT(*) FILTER (
            WHERE customer_id IS NOT NULL
        ) * 100.0 / COUNT(*),
        2
    ) AS customer_identification_rate_pct
FROM bm_sales;




-- Inventory Baseline:
SELECT
    COUNT(*) AS inventory_records,
    SUM(stock_on_hand) AS total_stock_on_hand,

    COUNT(*) FILTER (
        WHERE stock_on_hand < reorder_point
    ) AS below_reorder_point,

    COUNT(*) FILTER (
        WHERE stock_on_hand < safety_stock
    ) AS below_safety_stock,

    ROUND(
        COUNT(*) FILTER (
            WHERE stock_on_hand < reorder_point
        ) * 100.0 / COUNT(*),
        2
    ) AS reorder_risk_pct,

    ROUND(
        COUNT(*) FILTER (
            WHERE stock_on_hand < safety_stock
        ) * 100.0 / COUNT(*),
        2
    ) AS safety_stock_risk_pct
FROM bm_inventory;