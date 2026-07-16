SELECT c.customer_id, c.email, c.first_name, c.last_name
FROM customers AS c
WHERE EXISTS (SELECT 1 FROM orders AS o WHERE o.customer_id = c.customer_id)
ORDER BY c.customer_id;
