-- Task (Q069): Return order_id, ordered_at, customer_id, customer_first_name, customer_last_name, and status for orders that contain at least one product with a unit_price of 1,000.00 or more. Include each qualifying order once.
-- Requirement: Order by ordered_at descending, then order_id descending.
SELECT o.order_id, o.ordered_at, c.customer_id,
       c.first_name AS customer_first_name, c.last_name AS customer_last_name, o.status
FROM orders AS o
JOIN customers AS c ON c.customer_id = o.customer_id
WHERE EXISTS (
    SELECT 1 FROM order_items AS oi
    JOIN products AS p ON p.product_id = oi.product_id
    WHERE oi.order_id = o.order_id AND p.unit_price >= 1000.00
)
ORDER BY o.ordered_at DESC, o.order_id DESC;
