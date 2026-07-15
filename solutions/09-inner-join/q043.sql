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
