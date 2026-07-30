-- Task (Q169): For every active customer, return customer_id, email, order_count, review_count, and delivered_item_total. order_count is the number of all orders, review_count is the number of reviews, and delivered_item_total is the sum of quantity multiplied by unit_price for delivered orders, using 0 for missing metrics. Build independent aggregate result sets before joining them to customers.
-- Requirement: Order by customer_id ascending.
WITH order_counts AS (
    SELECT customer_id,
           COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
), review_counts AS (
    SELECT customer_id,
           COUNT(*) AS review_count
    FROM reviews
    GROUP BY customer_id
), delivered_totals AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
)
SELECT c.customer_id,
       c.email,
       COALESCE(oc.order_count, 0) AS order_count,
       COALESCE(rc.review_count, 0) AS review_count,
       COALESCE(dt.delivered_item_total, 0) AS delivered_item_total
FROM customers AS c
LEFT JOIN order_counts AS oc ON oc.customer_id = c.customer_id
LEFT JOIN review_counts AS rc ON rc.customer_id = c.customer_id
LEFT JOIN delivered_totals AS dt ON dt.customer_id = c.customer_id
WHERE c.status = 'active'
ORDER BY c.customer_id;
