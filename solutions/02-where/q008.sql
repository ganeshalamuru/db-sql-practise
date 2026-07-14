SELECT order_id, customer_id, ordered_at, status
FROM orders
WHERE status = 'delivered'
  AND ordered_at >= TIMESTAMPTZ '2024-01-01 00:00:00+00'
  AND ordered_at < TIMESTAMPTZ '2025-01-01 00:00:00+00'
ORDER BY ordered_at, order_id;
