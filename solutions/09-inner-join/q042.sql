-- Task (Q042): Return order_id, ordered_at, status, customer_id, customer_first_name, and customer_last_name for delivered orders.
-- Requirement: Order by ordered_at descending, then order_id descending.
SELECT o.order_id,
       o.ordered_at,
       o.status,
       c.customer_id,
       c.first_name AS customer_first_name,
       c.last_name AS customer_last_name
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.status = 'delivered'
ORDER BY o.ordered_at DESC, o.order_id DESC;
