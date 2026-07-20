-- Task (Q014): Return order_id, product_id, quantity, unit_price, and line_total (quantity multiplied by unit_price) for all order items.
-- Requirement: Order by line_total descending, then order_id ascending, then product_id ascending.
SELECT order_id, product_id, quantity, unit_price, quantity * unit_price AS line_total
FROM order_items
ORDER BY line_total DESC, order_id, product_id;
