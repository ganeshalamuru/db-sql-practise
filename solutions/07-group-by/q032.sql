-- Task (Q032): Return customer_id, order_count, first_ordered_at, and last_ordered_at for each customer who has placed at least one order.
-- Requirement: Order by order_count descending, then customer_id ascending.
SELECT customer_id,
       COUNT(*) AS order_count,
       MIN(ordered_at) AS first_ordered_at,
       MAX(ordered_at) AS last_ordered_at
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC, customer_id;
