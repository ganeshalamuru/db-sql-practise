-- Task (Q075): Return order_id, ordered_at, customer_id, customer_first_name, customer_last_name, and order_item_count for orders placed by customers who have also submitted at least one review with a rating of 5. Include only orders containing at least two line items.
-- Requirement: Order by ordered_at descending, then order_id descending.
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
