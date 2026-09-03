-- ======================================
-- ADVANCED DATA ANALYTICS
-- =======================================

-- Analyse sales performance over time (month level)
SELECT 
    YEAR(order_date) AS sales_year,
    MONTH(order_date) AS sales_month,
    DATE_FORMAT(order_date, '%b') AS month_name,
    SUM(sales_amount) AS monthly_sales_total
FROM gold_fact_sales
GROUP BY 
    YEAR(order_date),
    MONTH(order_date),
    DATE_FORMAT(order_date, '%b')
ORDER BY 
    sales_year, 
    sales_month;

-- Analyse sales performance over years with number of customers information
SELECT
	YEAR(order_date) AS year,
	SUM(sales_amount) AS yearly_sales_total,
    COUNT(DISTINCT customer_key) AS nr_of_customers
FROM gold_fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- Calculate the total sales per month and running total of sales over time

WITH CTE AS (
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS sales_month,
	SUM(sales_amount) AS total_sales
FROM gold_fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY sales_month
)
SELECT
	sales_month,
	total_sales,
	SUM(total_sales) OVER (ORDER BY sales_month) AS running_sales_total
FROM CTE;

-- Calculate the monthly moving avearge price

WITH CTE AS (
SELECT
	DATE_FORMAT(order_date, '%Y-%m-01') AS sales_month,
    AVG(price) AS average_price
FROM gold_fact_sales
WHERE MONTH(order_date) IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
ORDER BY sales_month
)
SELECT
	sales_month,
    AVG(average_price) OVER (ORDER BY sales_month) AS moving_avg_price
FROM CTE;

/* Analyse the yearly performance of products by comparing their sales
to both the average sales performance of the products and the previous year's sales */

WITH CTE AS (
SELECT
	SUM(f.sales_amount) AS current_sales,
	YEAR(f.order_date) AS year,
	p.product_name AS product_name
FROM gold_fact_sales f
LEFT JOIN gold_dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name, YEAR(f.order_date)
)
SELECT
	year,
	product_name,
	current_sales,
	AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
	current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'above_average'
		WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'below_average'
		ELSE 0 END AS avg_flag,
		-- year-by-year sales analysis
	LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year) AS last_year_sales,
	current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year) AS diff_sales,
	CASE
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year) > 0 THEN 'increase'
		WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY year) < 0 THEN 'decrease'
		ELSE 'no change' END AS sales_flag
FROM CTE;

-- Which category contributes the most to overall sales?

WITH CTE AS (
	SELECT
		p.category AS category,
		SUM(f.sales_amount) AS total_sales
	FROM gold_fact_sales f
	LEFT JOIN gold_dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.category
)
SELECT
	category,
	total_sales,
	SUM(total_sales) OVER () AS overall_sales,
	CONCAT((total_sales/SUM(total_sales) OVER ()) * 100, '%') AS percentage_sales_contribution
FROM CTE;

/* Segment product into cost ranges and count how many product fall into each category */
WITH product_segment AS (
SELECT
	*,
	CASE
		WHEN product_cost < 700 THEN 'under 700'
		WHEN product_cost <= 1400 THEN '700-1400'
		ELSE 'over 1400' END AS product_range
FROM gold_dim_products
)
SELECT
product_range,
COUNT(product_key) total
FROM product_segment
GROUP BY product_range;

/* Group customer into three categories based on their spending behaviour:
- VIP: Customer with at least 12 months of history and spending more than $5,000.
- Regular: Cutsomer with at 12 months of history but spending $5,000 or less.
- New: customer with less than 12 months history 
And find the total number of customers by each category
*/

WITH CTE AS (
	SELECT
			c.customer_key,
			TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS tenure_in_months,
			SUM(f.sales_amount) AS amount_spent,
			CASE 
				WHEN TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 AND SUM(f.sales_amount) > 5000 THEN 'VIP'
				WHEN TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) >= 12 AND SUM(f.sales_amount) <= 5000 THEN 'Regular'
				ELSE 'New'
			END AS customer_category
	FROM gold_fact_sales f
	LEFT JOIN gold_dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
    )
    SELECT
		customer_category,
		COUNT(customer_key) AS total_customers
    FROM CTE
    GROUP BY customer_category
    ORDER BY total_customers DESC;
