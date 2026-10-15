--Set Schema Search Path--
SET search_path TO ecom;

-- Overall total revenue and Order count--

SELECT 
COUNT(DISTINCT order_id) AS order_count,
ROUND(SUM(total), 2)  AS total_revenue
FROM ecom.orders
WHERE LOWER(status) = 'delivered';

--Monthly revenue, order count, and AOV over time--

SELECT
DATE_TRUNC('month', created_at)::DATE AS sales_month,
COUNT(DISTINCT order_id) AS order_count,
ROUND(SUM(total), 2) AS monthly_revenue,
ROUND(SUM(total)/COUNT(DISTINCT order_id), 2) AS AOV
FROM ecom.orders  
WHERE LOWER(status) = 'delivered'
GROUP BY DATE_TRUNC('month', created_at)::date
ORDER BY sales_month;

--Month Over Month revenue growth and order growrth--
 WITH Monthly AS (
    SELECT 
    DATE_TRUNC('month', created_at)::DATE AS sales_month,
    COUNT(DISTINCT order_id) AS order_count,
    ROUND(SUM(total), 2) AS monthly_revenue
    FROM ecom.orders  
    WHERE LOWER(TRIM(status)) = 'delivered'
    GROUP BY DATE_TRUNC('month', created_at)
),
growth AS (
    SELECT 
    sales_month, order_count, monthly_revenue,
    LAG(monthly_revenue) OVER (ORDER BY sales_month) AS previous_revenue,
    LAG(order_count) OVER (ORDER BY sales_month) AS previous_orders
    FROM Monthly
)
SELECT 
Sales_month, order_count, monthly_revenue, previous_revenue, previous_orders,
ROUND(
    CASE 
    WHEN previous_revenue IS NULL OR previous_revenue = 0 THEN NULL
    ELSE ((Monthly_revenue-previous_revenue)/NULLIF(previous_revenue, 0))*100.0 
    END, 2) AS Revenue_growth_percentage,
ROUND(
    CASE
    WHEN previous_orders IS NULL OR previous_orders = 0 THEN NULL
    ELSE(order_count-previous_orders)::numeric /NULLIF(previous_orders, 0)*100.0
    END, 2) AS Order_growth_percentage
FROM growth
ORDER BY sales_month;

--Total Revenue--
--Average Revenue per order and Average revenue per customer--

SELECT
COUNT(DISTINCT order_id) AS total_orders,
COUNT(DISTINCT customer_id) AS total_customers,
SUM(total) AS Revenue,
ROUND(SUM(total)/COUNT(DISTINCT order_id) , 2) as avg_revenue_per_order,
ROUND(SUM(total)/COUNT(DISTINCT customer_id) , 2) as avg_revenue_per_customer
FROM orders
WHERE LOWER(TRIM(status)) = 'delivered';

--Average order per customer--

SELECT 
Count(order_id) AS total_orders, Count(DISTINCT customer_id) AS total_customers, 
count(DISTINCT order_id)::numeric /count(DISTINCT customer_id) AS avg_order_per_customer
FROM ecom.orders
WHERE LOWER(TRIM(status)) ='delivered';

--Average items per delivered order--

SELECT 
MAX(qty) AS maximum_items,
MIN(qty) AS minimum_items,
COUNT(DISTINCT o.Order_id) AS delivered_orders, SUM(i.qty)/ COUNT(DISTINCT o.Order_id) AS average_items_delivered_orders
FROM orders o
JOIN order_items i
ON o.order_id = i.order_id
WHERE LOWER(o.Status) = 'delivered';







