-- Descriptive Analysis:
/*
	Q- What happened in the business?
	Overall - what does overall business look like?
*/

SELECT
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit) / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    SUM(discount_amount) AS discount_amount,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate,
    COUNT(*) AS sales_records,
    COUNT(DISTINCT sku_id) AS active_skus,
    COUNT(DISTINCT store_id) AS active_stores
FROM vw_sales_enriched;


-- Q How did sales performance change over time?
SELECT
    DATE_TRUNC('month', date)::date AS month,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    COUNT(*) AS sales_records
FROM vw_sales_enriched
GROUP BY 1
ORDER BY 1;

-- Q Monthly Growth:
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', date)::date AS month,
        SUM(net_sales) AS net_sales,
        SUM(gross_profit) AS gross_profit,
        SUM(quantity) AS units_sold
    FROM vw_sales_enriched
    GROUP BY 1
)
SELECT
    month,
    net_sales,
    units_sold,
    gross_profit,
    ROUND(
        (
            net_sales
            - LAG(net_sales) OVER (ORDER BY month)
        )
        / NULLIF(
            LAG(net_sales) OVER (ORDER BY month),
            0
        ) * 100,
        2
    ) AS mom_sales_growth_pct
FROM monthly_sales
ORDER BY month;

-- Monthly Profitability:
SELECT
    DATE_TRUNC('month', date)::date AS month,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    SUM(discount_amount) AS discount_amount,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate
FROM vw_sales_enriched
GROUP BY 1
ORDER BY 1;

--#  Store Performance Analysis:
SELECT
    store_id,
    store_name,
    store_city,
    store_type,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    SUM(discount_amount) AS discount_amount,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate,
    COUNT(*) AS sales_records
FROM vw_sales_enriched
GROUP BY
    store_id,
    store_name,
    store_city,
    store_type
ORDER BY net_sales DESC;

-- Category Performance:
SELECT
    category,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    SUM(discount_amount) AS discount_amount,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate,
    COUNT(DISTINCT sku_id) AS sku_count
FROM vw_sales_enriched
GROUP BY category
ORDER BY net_sales DESC;


-- SKU & Brand Performance
SELECT
    sku_id,
    sku_name,
    category,
    subcategory,
    brand,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    SUM(discount_amount) AS discount_amount
FROM vw_sales_enriched
GROUP BY
    sku_id,
    sku_name,
    category,
    subcategory,
    brand
ORDER BY net_sales DESC
LIMIT 20;

-- 20 SKU performance:
SELECT
    sku_id,
    sku_name,
    category,
    brand,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct
FROM vw_sales_enriched
GROUP BY
    sku_id,
    sku_name,
    category,
    brand
ORDER BY gross_profit DESC
LIMIT 20;

-- Channel and Customer:
-- Which sales channels contribute most to sales, units, profit, and margin?
SELECT
    channel,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    SUM(discount_amount) AS discount_amount,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate,
    COUNT(*) AS sales_records
FROM vw_sales_enriched
GROUP BY channel
ORDER BY net_sales DESC;

-- Loyalty Performance 
--How do customer loyalty segments differ in commercial contribution?
SELECT
    loyalty_segment,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    COUNT(*) AS sales_records
FROM vw_sales_enriched
WHERE customer_id IS NOT NULL
GROUP BY loyalty_segment
ORDER BY net_sales DESC;

-- Customer Value & Channel Preference
-- How does customer behavior differ across loyalty segments and actual sales channels?
SELECT
    loyalty_segment,
    channel,
    COUNT(DISTINCT customer_id) AS customers,
    SUM(net_sales) AS net_sales,
    SUM(quantity) AS units_sold,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(net_sales)
        / NULLIF(COUNT(DISTINCT customer_id), 0),
        2
    ) AS revenue_per_customer,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct
FROM vw_sales_enriched
WHERE customer_id IS NOT NULL
GROUP BY
    loyalty_segment,
    channel
ORDER BY
    loyalty_segment,
    net_sales DESC;


-- Discount & Inventory Position  
-- How is sales activity distributed across discount levels?
SELECT
    CASE
        WHEN discount_pct = 0 THEN '0%'
        WHEN discount_pct <= 5 THEN '1-5%'
        WHEN discount_pct <= 10 THEN '6-10%'
        WHEN discount_pct <= 15 THEN '11-15%'
        WHEN discount_pct <= 20 THEN '16-20%'
        WHEN discount_pct <= 25 THEN '21-25%'
        WHEN discount_pct <= 30 THEN '26-30%'
        ELSE '31%+'
    END AS discount_band,
    COUNT(*) AS sales_records,
    SUM(quantity) AS units_sold,
    SUM(net_sales) AS net_sales,
    SUM(discount_amount) AS discount_amount,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct
FROM vw_sales_enriched
GROUP BY 1
ORDER BY
    MIN(discount_pct);	


-- Inventory Position — 2025-10-31
-- What is the current inventory risk position across store-SKU combinations?	
SELECT
    inventory_status,
    COUNT(*) AS store_sku_records,
    SUM(stock_on_hand) AS total_stock_on_hand,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS record_share_pct
FROM vw_inventory_risk
GROUP BY inventory_status
ORDER BY
    CASE inventory_status
        WHEN 'Below Safety Stock' THEN 1
        WHEN 'Below Reorder Point' THEN 2
        WHEN 'Normal' THEN 3
    END;


-- Diagnostic Analysis:

-- Profitability Leakage:
-- Where are we generating sales but failing to convert them into strong profit?

SELECT
    category,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(net_sales)
        / SUM(SUM(net_sales)) OVER () * 100,
        2
    ) AS sales_contribution_pct,
    ROUND(
        SUM(gross_profit)
        / SUM(SUM(gross_profit)) OVER () * 100,
        2
    ) AS profit_contribution_pct
FROM vw_sales_enriched
GROUP BY category
ORDER BY net_sales DESC;


-- Discount → Margin Driver Analysis:
SELECT
    CASE
        WHEN discount_pct = 0 THEN '0%'
        WHEN discount_pct <= 5 THEN '1-5%'
        WHEN discount_pct <= 10 THEN '6-10%'
        WHEN discount_pct <= 15 THEN '11-15%'
        WHEN discount_pct <= 20 THEN '16-20%'
        WHEN discount_pct <= 25 THEN '21-25%'
        WHEN discount_pct <= 30 THEN '26-30%'
        ELSE '31%+'
    END AS discount_band,
    COUNT(*) AS sales_records,
    SUM(quantity) AS units_sold,
    SUM(net_sales) AS net_sales,
    SUM(discount_amount) AS discount_amount,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct
FROM vw_sales_enriched
GROUP BY 1
ORDER BY MIN(discount_pct);

--Product / Category Root Cause:
SELECT
    category,
    subcategory,
    brand,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate
FROM vw_sales_enriched
WHERE category = 'Personal Care'
GROUP BY
    category,
    subcategory,
    brand
ORDER BY gross_margin_pct;

-- SKU drivers:
SELECT
    sku_id,
    sku_name,
    subcategory,
    brand,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate
FROM vw_sales_enriched
WHERE category = 'Personal Care'
GROUP BY
    sku_id,
    sku_name,
    subcategory,
    brand
ORDER BY net_sales DESC;

-- Prescriptive Analysis:
-- Which products/categories should be prioritized for discount review?
SELECT
    category,
    subcategory,
    brand,
    sku_id,
    sku_name,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales), 0) * 100,
        2
    ) AS gross_margin_pct,
    ROUND(
        SUM(discount_amount)
        / NULLIF(SUM(gross_list_value), 0) * 100,
        2
    ) AS discount_rate
FROM vw_sales_enriched
WHERE discount_pct >= 21
GROUP BY
    category,
    subcategory,
    brand,
    sku_id,
    sku_name
ORDER BY net_sales DESC;
-- pricing/discount review based on actual commercial exposure--


-- Product Economics Actions:
SELECT
    sku_id,
    sku_name,
    category,
    subcategory,
    brand,
    MAX(list_price) AS list_price,
    MAX(selling_price) AS realized_selling_price,
    MAX(selling_price) -
        MAX(list_price) AS price_gap,
    MAX(selling_price) -
        MAX(product_cost / NULLIF(quantity,0)) AS unit_profit,
    SUM(net_sales) AS net_sales,
    SUM(gross_profit) AS gross_profit,
    ROUND(
        SUM(gross_profit)
        / NULLIF(SUM(net_sales),0) * 100,
        2
    ) AS gross_margin_pct
FROM vw_sales_enriched
WHERE category = 'Personal Care'
GROUP BY
    sku_id,
    sku_name,
    category,
    subcategory,
    brand
HAVING SUM(net_sales) > 300000
ORDER BY gross_margin_pct ASC;


