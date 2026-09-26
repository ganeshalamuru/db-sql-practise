-- Task (Q162): Using CROSS APPLY, return the most recent order for each customer who has placed an order. Return customer_id, order_id, ordered_at, and status.
-- Requirement: Order by customer_id ascending.
SELECT c.customer_id, recent.order_id, recent.ordered_at, recent.status
FROM customers AS c
CROSS APPLY (
    SELECT TOP 1 o.order_id, o.ordered_at, o.status
    FROM orders AS o
    WHERE o.customer_id = c.customer_id
    ORDER BY o.ordered_at DESC, o.order_id DESC
) AS recent
ORDER BY c.customer_id;
