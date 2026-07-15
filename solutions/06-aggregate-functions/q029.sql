SELECT COUNT(*) AS active_product_count,
       MIN(unit_price) AS lowest_active_product_price,
       MAX(unit_price) AS highest_active_product_price,
       ROUND(AVG(unit_price), 2) AS average_active_product_price
FROM products
WHERE is_active;
