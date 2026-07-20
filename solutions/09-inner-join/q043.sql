-- Task (Q043): Return order_id, ordered_at, product_id, quantity, unit_price, and line_total for order items on paid, shipped, or delivered orders. line_total is quantity multiplied by unit_price.
-- Requirement: Order by ordered_at descending, then order_id descending, then product_id ascending.
SELECT o.order_id,
       o.ordered_at,
       oi.product_id,
       oi.quantity,
       oi.unit_price,
       oi.quantity * oi.unit_price AS line_total
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.status IN ('paid', 'shipped', 'delivered')
ORDER BY o.ordered_at DESC, o.order_id DESC, oi.product_id;
