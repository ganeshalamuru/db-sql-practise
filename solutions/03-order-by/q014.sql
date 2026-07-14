SELECT order_id, product_id, quantity, unit_price, quantity * unit_price AS line_total
FROM order_items
ORDER BY line_total DESC, order_id, product_id;
