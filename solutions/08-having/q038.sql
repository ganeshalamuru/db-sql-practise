-- Task (Q038): Return product_id and total_sales_value for products whose total value across all order items exceeds 25,000.00. Compute each line's value as quantity multiplied by unit_price.
-- Requirement: Order by total_sales_value descending, then product_id ascending.
SELECT product_id, SUM(quantity * unit_price) AS total_sales_value
FROM order_items
GROUP BY product_id
HAVING SUM(quantity * unit_price) > 25000.00
ORDER BY total_sales_value DESC, product_id;
