-- Task (Q013): Return order_id, customer_id, ordered_at, and status for all orders.
-- Requirement: Order by ordered_at descending, then order_id descending.
SELECT order_id, customer_id, ordered_at, status
FROM orders
ORDER BY ordered_at DESC, order_id DESC;
