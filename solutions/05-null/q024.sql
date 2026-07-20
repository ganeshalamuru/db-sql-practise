-- Task (Q024): Return order_id, customer_id, ordered_at, and status for cancelled orders that have no promotion applied.
-- Requirement: Order by order_id ascending.
SELECT order_id, customer_id, ordered_at, status
FROM orders
WHERE status = 'cancelled'
  AND promotion_id IS NULL
ORDER BY order_id;
