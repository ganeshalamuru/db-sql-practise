-- Task (Q175): For each city, return the top three active customers by delivered_item_total, retaining ties. Return city_id, city_name, customer_id, email, delivered_order_count, delivered_item_total, review_count, last_activity_at, and city_value_rank. Consider only active customers with at least one delivered order. delivered_item_total is the sum of quantity multiplied by unit_price in delivered orders; last_activity_at is the latest delivered ordered_at or review created_at timestamp; city_value_rank ranks customers by delivered_item_total descending within their city.
-- Requirement: Order by city_id ascending, then city_value_rank ascending, then customer_id ascending.
WITH delivered_metrics AS (
    SELECT o.customer_id,
           COUNT(DISTINCT o.order_id) AS delivered_order_count,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total,
           MAX(o.ordered_at) AS last_delivered_ordered_at
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
), review_metrics AS (
    SELECT customer_id,
           COUNT(*) AS review_count,
           MAX(created_at) AS last_reviewed_at
    FROM reviews
    GROUP BY customer_id
), customer_metrics AS (
    SELECT c.city_id,
           city.name AS city_name,
           c.customer_id,
           c.email,
           dm.delivered_order_count,
           dm.delivered_item_total,
           COALESCE(rm.review_count, 0) AS review_count,
           GREATEST(dm.last_delivered_ordered_at, rm.last_reviewed_at) AS last_activity_at
    FROM customers AS c
    JOIN cities AS city ON city.city_id = c.city_id
    JOIN delivered_metrics AS dm ON dm.customer_id = c.customer_id
    LEFT JOIN review_metrics AS rm ON rm.customer_id = c.customer_id
    WHERE c.status = 'active'
), ranked_customers AS (
    SELECT city_id,
           city_name,
           customer_id,
           email,
           delivered_order_count,
           delivered_item_total,
           review_count,
           last_activity_at,
           RANK() OVER (
               PARTITION BY city_id
               ORDER BY delivered_item_total DESC
           ) AS city_value_rank
    FROM customer_metrics
)
SELECT city_id,
       city_name,
       customer_id,
       email,
       delivered_order_count,
       delivered_item_total,
       review_count,
       last_activity_at,
       city_value_rank
FROM ranked_customers
WHERE city_value_rank <= 3
ORDER BY city_id, city_value_rank, customer_id;
