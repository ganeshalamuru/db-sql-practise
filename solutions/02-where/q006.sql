-- Task (Q006): Return customer_id, email, first_name, and last_name for active customers.
-- Requirement: Order by customer_id ascending.
SELECT customer_id, email, first_name, last_name
FROM customers
WHERE status = 'active'
ORDER BY customer_id;
