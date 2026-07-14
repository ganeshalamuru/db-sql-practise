SELECT order_id, customer_id, ordered_at, status
FROM orders
WHERE status = 'cancelled'
  AND promotion_id IS NULL
ORDER BY order_id;
