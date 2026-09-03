/*
====================================================================
Product Report
=====================================================================
Purpose:
- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range and Low-Performers.
3. Aggregates product level metrics:
	- Total orders
	- Total sales
	- Total quanity sold
	- Total customers (unique)
	- lifespan
4. Calculates valuable KPIs:
	- recency (months since last sale)
	- average order value (AOV)
	- average monthly revenue
*/

CREATE VIEW gold_report_products AS
WITH base_query AS (
/* -----------------------------------------------------------------
1) Base Query: Retrieve core columns from tables
------------------------------------------------------------------*/
SELECT
	p.product_key,
    f.customer_key,
	f.order_number,
	p.product_number,
	p.product_name,
	p.category,
	p.subcategory,
    f.quantity,
	p.product_cost,
	f.sales_amount,
	f.order_date
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
ON p.product_key = f.product_key
WHERE f.order_date IS NOT NULL
)
, product_aggregations AS (
/*-------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
----------------------------------------------------------------------*/
SELECT
product_key,
product_number,
product_name,
category,
subcategory,
product_cost,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS revenue,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY
	product_key,
	product_number,
	product_name,
	category,
	subcategory,
    product_cost
)
SELECT
	product_key,
	product_number,
	product_name,
    category,
	subcategory,
    product_cost,
    lifespan,
	total_orders,
    total_quantity,
    total_customers,
	revenue,
    CASE
		WHEN revenue <= 40000 THEN 'Low-Performer'
		WHEN revenue < 80000 THEN 'Mid-Range'
		ELSE 'High-Performer'
    END AS product_segment,
    -- compute order recency
    TIMESTAMPDIFF(month, last_order_date, NOW()) AS recency,
    -- compute average order revenue
    revenue/NULLIF(total_orders, 0) AS avg_order_revenue,
    -- compute average monthy revenue
    revenue/NULLIF(lifespan, 0) AS avg_monthly_revenue 
    FROM product_aggregations
    ORDER BY category, subcategory, product_name;

SELECT * FROM gold_report_products;
