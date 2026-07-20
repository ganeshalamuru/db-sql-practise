-- Task (Q063): Return customer_id, email, first_name, and last_name for customers who have placed more orders than the average number of orders per customer. Treat the average as the total number of orders divided by the number of distinct customers who placed an order.
-- Requirement: Order by customer_id ascending.
SELECT c.customer_id,
       c.email,
       c.first_name,
       c.last_name
FROM customers AS c
WHERE (
    SELECT COUNT(*)
    FROM orders AS o
    WHERE o.customer_id = c.customer_id
) > (
    SELECT COUNT(*)::NUMERIC / COUNT(DISTINCT customer_id)
    FROM orders
)
ORDER BY c.customer_id;
