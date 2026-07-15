SELECT customer_id,
       COUNT(*) AS order_count,
       MIN(ordered_at) AS first_ordered_at,
       MAX(ordered_at) AS last_ordered_at
FROM orders
GROUP BY customer_id
ORDER BY order_count DESC, customer_id;
