SELECT o.order_id, o.ordered_at, c.customer_id,
       c.first_name AS customer_first_name, c.last_name AS customer_last_name,
       COUNT(oi.product_id) AS order_item_count
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.customer_id IN (
    SELECT r.customer_id FROM reviews AS r WHERE r.rating = 5
)
GROUP BY o.order_id, o.ordered_at, c.customer_id, c.first_name, c.last_name
HAVING COUNT(oi.product_id) >= 2
ORDER BY o.ordered_at DESC, o.order_id DESC;
