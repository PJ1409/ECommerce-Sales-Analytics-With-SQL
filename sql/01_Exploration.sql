--Set Schema Search Path--
SET search_path TO ecom;

--List all the tables in the ecom schema--

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'ecom'
ORDER BY table_name;

--Display the contents of each table--

SELECT * 
FROM ecom.customers
LIMIT 10;
SELECT * 
FROM ecom.orders
LIMIT 10;
SELECT * 
FROM ecom.order_items
LIMIT 10;
SELECT * 
FROM ecom.products
LIMIT 10;
SELECT *
FROM ecom.devices;
SELECT *
FROM ecom.categories;
SELECT *
FROM ecom.brands;

--Total Number of Orders And Number of Customers who placed orders--

SELECT COUNT(*) AS total_Orders, 
       COUNT(DISTINCT Customer_Id) AS total_customers
FROM ecom.Orders;

--Determine the order span of the order data--

SELECT 
       MIN(Created_at) AS earliest_order,
       MAX(Created_at) AS latest_Order
FROM ecom.orders;

--Total Number of Unique Customers--

SELECT COUNT(DISTINCT Customer_Id) 
FROM ecom.Customers;

--Total Revenue--
--Average Revenue per order and Average revenue per customer--

SELECT
COUNT(DISTINCT order_id) AS total_orders,
COUNT(DISTINCT customer_id) AS total_customers,
SUM(total) AS Revenue,
ROUND(SUM(total)/COUNT(DISTINCT order_id) , 2) as avg_revenue_per_order,
ROUND(SUM(total)/COUNT(DISTINCT customer_id) , 2) as avg_revenue_per_customer
FROM orders;

---Total number of products--

SELECT
COUNT(DISTINCT Product_id) 
FROM ecom.products;

--Number of products based on each Product categories--

SELECT 
    c.parent_id,
    SUM(CASE WHEN p.is_active = 'TRUE' THEN 1 ELSE 0 END) AS total_active_products,
    COUNT(DISTINCT c.category_id) AS category_count,
    STRING_AGG(c.category_name, ', ') AS categories
FROM products p
JOIN categories c 
    ON c.category_id = p.category_id
GROUP BY c.parent_id
ORDER BY total_active_products DESC;

--Percentage of active products--

SELECT 
COUNT(DISTINCT product_id) AS total_products,
COUNT(DISTINCT product_id) FILTER (WHERE is_active ='TRUE')*100.0
/COUNT(DISTINCT product_id) AS pct_average_products
FROM ecom.products;

--Overall monthly revenue, order count, customer count, AOV--

SELECT
DATE_TRUNC('month', created_at)::DATE AS sales_month,
COUNT(DISTINCT Customer_Id) AS customers,
COUNT(DISTINCT order_id) AS order_count,
ROUND(SUM(total), 2) AS monthly_revenue,
ROUND(SUM(total)/COUNT(DISTINCT order_id), 2) AS AOV
FROM ecom.orders  
GROUP BY DATE_TRUNC('month', created_at)::date
ORDER BY sales_month;

--Overall average orders per customer--
SELECT 
Count(order_id) AS total_orders, Count(DISTINCT customer_id) AS total_customers, 
count(DISTINCT order_id)::numeric /count(DISTINCT customer_id) AS avg_order_per_customer
FROM ecom.orders;


--Average Order value--

SELECT 
COUNT(DISTINCT Order_id) AS total_orders, SUM(qty*Unit_price)/COUNT(DISTINCT order_id) AS Avg_order_value
FROM ecom.order_items;

--Average Discount Per order--

SELECT 
COUNT(order_id) AS total_orders, SUM(Discount)/COUNT(order_id) AS Discount_per_order
FROM ecom.orders;

--Refund rate for the orders--

SELECT 
COUNT(o.order_id) AS total_orders, COUNT(r.order_id) AS refund_orders, 
(COUNT(r.order_id)*100.0/NULLIF(COUNT(o.order_id),0)) AS refud_rate
FROM ecom.orders o
LEFT JOIN ecom.refunds r
ON o.order_id = r.order_id;


--Average items per order--

SELECT 
MAX(qty) AS maximum_items,
MIN(qty) AS minimum_items,
COUNT(DISTINCT o.Order_id) AS delivered_orders, SUM(i.qty)/ COUNT(DISTINCT o.Order_id) AS average_items_delivered_orders
FROM orders o
JOIN order_items i
ON o.order_id = i.order_id;

--Number of distinct delivered orders under each category--

SELECT 
c.category_name,
COUNT(DISTINCT ot.order_id) AS total_orders
FROM ecom.categories c
JOIN ecom.products p
ON c.category_id = p.category_id
JOIN ecom.product_variants pv
ON p.product_id = pv.product_id
JOIN ecom.order_items ot
ON pv.variant_id = ot.variant_id
JOIN ecom.orders o
ON ot.order_id = o.order_id
GROUP BY c.category_name
ORDER BY total_orders DESC;