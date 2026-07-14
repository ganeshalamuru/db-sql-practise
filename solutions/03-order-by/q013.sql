SELECT order_id, customer_id, ordered_at, status
FROM orders
ORDER BY ordered_at DESC, order_id DESC;
