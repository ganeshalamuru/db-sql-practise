SELECT customer_id, email, first_name, last_name
FROM customers
WHERE status = 'active'
ORDER BY customer_id;
