-- Superstore SQL Analysis
-- Database: superstore_db | Tables: orders, customers, products

-- Q1: Which regions bring in the most sales and profit, and how efficiently? (GROUP BY)
SELECT region,
       ROUND(SUM(sales))  AS total_sales,
       ROUND(SUM(profit)) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 1) AS margin_pct
FROM orders
GROUP BY region
ORDER BY total_sales DESC;

-- Q2: How do sales and profit trend month by month? (GROUP BY with date functions)
SELECT YEAR(order_date)  AS yr,
       MONTH(order_date) AS mth,
       ROUND(SUM(sales))  AS total_sales,
       ROUND(SUM(profit)) AS total_profit
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY yr, mth;


-- Q3: Who are the top 10 customers by sales, and is their business profitable? (JOIN)
SELECT c.customer_name,
       c.segment,
       COUNT(DISTINCT o.order_id) AS orders,
       ROUND(SUM(o.sales))  AS total_sales,
       ROUND(SUM(o.profit)) AS total_profit
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.segment
ORDER BY total_sales DESC
LIMIT 10;


-- Q4: Which 10 products lose the most money overall? (JOIN + HAVING)
SELECT p.product_name,
       p.sub_category,
       ROUND(SUM(o.sales))  AS total_sales,
       ROUND(SUM(o.profit)) AS total_profit
FROM orders o
JOIN products p ON p.product_id = o.product_id
GROUP BY p.product_id, p.product_name, p.sub_category
HAVING SUM(o.profit) < 0
ORDER BY total_profit ASC
LIMIT 10;


-- Q5: Which sub-categories earn a lower margin than the company average? (SUBQUERY)
SELECT p.sub_category,
       ROUND(SUM(o.sales))  AS total_sales,
       ROUND(SUM(o.profit)) AS total_profit,
       ROUND(SUM(o.profit) / SUM(o.sales) * 100, 1) AS margin_pct
FROM orders o
JOIN products p ON p.product_id = o.product_id
GROUP BY p.sub_category
HAVING SUM(o.profit) / SUM(o.sales) <
       (SELECT SUM(profit) / SUM(sales) FROM orders)
ORDER BY margin_pct;


-- Q6: How does the discount level affect profit? (CASE + GROUP BY)
SELECT CASE
         WHEN discount = 0    THEN '1. No discount'
         WHEN discount <= 0.2 THEN '2. Up to 20%'
         WHEN discount <= 0.4 THEN '3. 21-40%'
         ELSE                      '4. Over 40%'
       END AS discount_band,
       COUNT(*)           AS order_lines,
       ROUND(SUM(sales))  AS total_sales,
       ROUND(SUM(profit)) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 1) AS margin_pct
FROM orders
GROUP BY discount_band
ORDER BY discount_band;


-- Q7: Which are the top 10 states by sales, and are they profitable? (GROUP BY + ORDER BY)
SELECT state,
       ROUND(SUM(sales))  AS total_sales,
       ROUND(SUM(profit)) AS total_profit,
       ROUND(SUM(profit) / SUM(sales) * 100, 1) AS margin_pct
FROM orders
GROUP BY state
ORDER BY total_sales DESC
LIMIT 10;

-- Q8: How many days does each shipping mode actually take? (DATEDIFF + AVG)
SELECT ship_mode,
       COUNT(*) AS order_lines,
       ROUND(AVG(DATEDIFF(ship_date, order_date)), 1) AS avg_days_to_ship,
       MAX(DATEDIFF(ship_date, order_date))           AS slowest_days
FROM orders
GROUP BY ship_mode
ORDER BY avg_days_to_ship;


-- Q9: How fast is revenue growing year over year? (CTE + LAG window function)
WITH yearly AS (
  SELECT YEAR(order_date) AS yr,
         SUM(sales)       AS total_sales
  FROM orders
  GROUP BY YEAR(order_date)
)
SELECT yr,
       ROUND(total_sales) AS total_sales,
       ROUND((total_sales - LAG(total_sales) OVER (ORDER BY yr))
             / LAG(total_sales) OVER (ORDER BY yr) * 100, 1) AS yoy_growth_pct
FROM yearly
ORDER BY yr;


-- Q10: Which customer segment is the most valuable? (JOIN + multiple aggregates)
SELECT c.segment,
       COUNT(DISTINCT c.customer_id) AS customers,
       ROUND(SUM(o.sales))  AS total_sales,
       ROUND(SUM(o.profit)) AS total_profit,
       ROUND(SUM(o.profit) / SUM(o.sales) * 100, 1) AS margin_pct,
       ROUND(SUM(o.sales) / COUNT(DISTINCT o.order_id)) AS avg_order_value
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.segment
ORDER BY total_sales DESC;