SELECT order_id, product_id, quantity, unit_price, quantity * unit_price AS line_total
FROM order_items
ORDER BY order_id, product_id;
