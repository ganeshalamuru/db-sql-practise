-- Task (Q029): For active products only, return active_product_count, lowest_active_product_price, highest_active_product_price, and average_active_product_price. Round the average price to two decimal places.
-- Requirement: The result has one row; no ordering is needed.
SELECT COUNT(*) AS active_product_count,
       MIN(unit_price) AS lowest_active_product_price,
       MAX(unit_price) AS highest_active_product_price,
       ROUND(AVG(unit_price), 2) AS average_active_product_price
FROM products
WHERE is_active;
