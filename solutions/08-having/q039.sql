-- Task (Q039): Return supplier_id and active_product_count for suppliers with at least 10 active products. Exclude inactive products before forming groups.
-- Requirement: Order by active_product_count descending, then supplier_id ascending.
SELECT supplier_id, COUNT(*) AS active_product_count
FROM products
WHERE is_active
GROUP BY supplier_id
HAVING COUNT(*) >= 10
ORDER BY active_product_count DESC, supplier_id;
