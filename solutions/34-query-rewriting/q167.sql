-- Task (Q167): Using a join, GROUP BY, and HAVING rather than a correlated subquery, return customer_id, email, and order_count for customers who have placed at least three orders.
-- Requirement: Order by customer_id ascending.
SELECT c.customer_id,
       c.email,
       COUNT(o.order_id) AS order_count
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.email
HAVING COUNT(o.order_id) >= 3
ORDER BY c.customer_id;
