SELECT o.order_id,
       o.ordered_at,
       o.status,
       c.customer_id,
       c.first_name AS customer_first_name,
       c.last_name AS customer_last_name
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE o.status = 'delivered'
ORDER BY o.ordered_at DESC, o.order_id DESC;
