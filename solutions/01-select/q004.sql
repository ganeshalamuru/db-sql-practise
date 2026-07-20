-- Task (Q004): For every order item, return order_id, product_id, quantity, unit_price, and the line total (quantity multiplied by unit_price) as line_total.
-- Requirement: Order by order_id, then product_id.
SELECT order_id, product_id, quantity, unit_price, quantity * unit_price AS line_total
FROM order_items
ORDER BY order_id, product_id;
