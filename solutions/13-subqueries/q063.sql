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
