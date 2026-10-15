--Set Schema Search Path--
SET search_path TO ecom;

--Customer Segmentation based on delivered order--
--Segmentation based average order count and lifetime spent--

WITH Customer_summary AS (
    SELECT 
   c.customer_id, 
   COUNT(DISTINCT o.order_id) AS total_orders,
   COALESCE(SUM(o.total), 0) AS lifetime_spend
   FROM customers c
   LEFT JOIN orders o
   ON c.customer_id = o.customer_id
   WHERE LOWER(TRIM(o.status)) = 'delivered'
   GROUP BY c.customer_id
),
Customer_segments AS (
    SELECT customer_id, total_orders, lifetime_spend,
    CASE 
    WHEN total_orders = 0 THEN 'No Orders'
    WHEN total_orders = 1 THEN 'One Time Buyers'
    WHEN total_orders BETWEEN 2 AND 4 THEN 'Repeat Buyer'
    WHEN total_orders >= 5 THEN 'VIP Buyer'
    END AS Segment
    FROM customer_summary
    )
    
SELECT 
    Segment,
    COUNT(*) AS customer_count,
    ROUND(COUNT(*) *100.0/(SELECT COUNT(*) FROM customer_segments), 2) AS ptc_customer,
    SUM(lifetime_spend) AS segment_revenue,
    ROUND(SUM(lifetime_spend)*100/(SELECT SUM(lifetime_spend) FROM customer_segments), 2) AS ptc_revenue,
    ROUND(AVG(total_orders), 2) AS avg_order_count,
    ROUND(AVG(lifetime_spend), 2) AS avg_lifetime_spend
    FROM customer_segments
    GROUP BY Segment
    ORDER BY ptc_revenue DESC;

-- Repeat Buyer value VS one-time Buyer Ratio--

WITH Customer_summary AS (
    SELECT 
    c.customer_id, 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(o.total), 0) AS lifetime_spend
    FROM customers c
    LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
    GROUP BY c.customer_id
),
Customer_segments AS (
    SELECT customer_id, total_orders, lifetime_spend,
    CASE 
    WHEN total_orders = 0 THEN 'No Orders'
    WHEN total_orders = 1 THEN 'One Time Buyers'
    WHEN total_orders BETWEEN 2 AND 4 THEN 'Repeat Buyer'
    WHEN total_orders >= 5 THEN 'VIP Buyer'
    END AS Segment
    FROM customer_summary
    )
SELECT 
ROUND(
    AVG(lifetime_spend) FILTER (WHERE segment ='Repeat Buyer')
    /
    AVG(lifetime_spend) FILTER  (WHERE segment = 'One Time Buyers'),
    2
) AS repeate_VS_onetime_buyer_ratio
FROM customer_segments;

--Period Between Earliest order and Latest Order--

SELECT 
Customer_id, 
MAX(created_at) AS latest_order,
MIN(created_at) AS earliest_order,
EXTRACT(DAY FROM AGE(MAX(created_at),MIN(created_at))) AS period_between_first_and_last_order
FROM ecom.orders
GROUP BY Customer_id;

-- Top Customers--

WITH Customer_summary AS (
    SELECT 
    c.customer_id, 
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(o.total), 0) AS lifetime_spend
    FROM customers c
    LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    WHERE LOWER(TRIM(o.status)) = 'delivered'
    GROUP BY c.customer_id
),
customer_ranking AS (
    SELECT
    Customer_id,
    lifetime_spend,
    NTILE(5) OVER(ORDER BY lifetime_spend DESC) AS top_customer_groups
    FROM customer_summary
)
SELECT 
top_customer_groups,
SUM(lifetime_spend) AS revenue,
ROUND(SUM(lifetime_spend)*100/(SELECT SUM(lifetime_spend)FROM customer_summary),2) AS shared_revenue_percentage
FROM customer_ranking
GROUP BY top_customer_groups
ORDER BY top_customer_groups;




    

