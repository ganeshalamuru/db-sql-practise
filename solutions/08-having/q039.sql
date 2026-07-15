SELECT supplier_id, COUNT(*) AS active_product_count
FROM products
WHERE is_active
GROUP BY supplier_id
HAVING COUNT(*) >= 10
ORDER BY active_product_count DESC, supplier_id;
