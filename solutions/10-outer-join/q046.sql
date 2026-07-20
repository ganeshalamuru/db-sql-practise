-- Task (Q046): Return customer_id, email, first_name, and last_name for customers who have never placed an order.
-- Requirement: Order by customer_id ascending.
SELECT c.customer_id, c.email, c.first_name, c.last_name
FROM customers AS c
LEFT JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL
ORDER BY c.customer_id;
