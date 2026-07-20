-- Task (Q016): Return order_id, product_id, quantity, unit_price, and line_total (quantity multiplied by unit_price) for every order item.
-- Requirement: Order by order_id ascending, then product_id ascending.
SELECT
    order_id,
    product_id,
    quantity,
    unit_price,
    quantity * unit_price AS line_total
FROM order_items
ORDER BY order_id, product_id;
