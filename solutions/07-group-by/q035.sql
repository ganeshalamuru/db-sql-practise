SELECT supplier_id,
       COUNT(*) AS active_product_count,
       ROUND(AVG(unit_price), 2) AS average_active_product_price
FROM products
WHERE is_active
GROUP BY supplier_id
ORDER BY average_active_product_price DESC, active_product_count DESC, supplier_id;
