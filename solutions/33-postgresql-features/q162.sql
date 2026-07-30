-- Task (Q162): Using DISTINCT ON, return the most recent order for each customer who has placed an order. Return customer_id, order_id, ordered_at, and status.
-- Requirement: Order by customer_id ascending.
SELECT customer_id,
       order_id,
       ordered_at,
       status
FROM (
    SELECT DISTINCT ON (customer_id)
           customer_id,
           order_id,
           ordered_at,
           status
    FROM orders
    ORDER BY customer_id, ordered_at DESC, order_id DESC
) AS latest_orders
ORDER BY customer_id;
