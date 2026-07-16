SELECT c.customer_id, c.email, c.first_name, c.last_name
FROM customers AS c
WHERE c.customer_id NOT IN (
    SELECT o.customer_id FROM orders AS o
    WHERE o.status IN ('paid', 'shipped', 'delivered')
)
ORDER BY c.customer_id;
