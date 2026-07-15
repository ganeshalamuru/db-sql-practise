SELECT product_id, SUM(quantity * unit_price) AS total_sales_value
FROM order_items
GROUP BY product_id
HAVING SUM(quantity * unit_price) > 25000.00
ORDER BY total_sales_value DESC, product_id;
