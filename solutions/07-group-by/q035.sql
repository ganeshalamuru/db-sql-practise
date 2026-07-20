-- Task (Q035): For active products only, return supplier_id, active_product_count, and average_active_product_price. Round average_active_product_price to two decimal places.
-- Requirement: Order by average_active_product_price descending, then active_product_count descending, then supplier_id ascending.
SELECT supplier_id,
       COUNT(*) AS active_product_count,
       ROUND(AVG(unit_price), 2) AS average_active_product_price
FROM products
WHERE is_active
GROUP BY supplier_id
ORDER BY average_active_product_price DESC, active_product_count DESC, supplier_id;
