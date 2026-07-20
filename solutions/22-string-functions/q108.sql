-- Task (Q108): Return supplier_id, supplier_name, category_id, category_name, active_product_count, and active_sku_list for each supplier-and-category combination with at least two active products. active_sku_list contains that combination's active SKUs separated by ', ' and sorted by SKU ascending.
-- Requirement: Order by supplier_id ascending, then category_id ascending.
SELECT s.supplier_id,
       s.name AS supplier_name,
       c.category_id,
       c.name AS category_name,
       COUNT(p.product_id) AS active_product_count,
       STRING_AGG(p.sku, ', ' ORDER BY p.sku) AS active_sku_list
FROM suppliers AS s
JOIN products AS p ON p.supplier_id = s.supplier_id
JOIN categories AS c ON c.category_id = p.category_id
WHERE p.is_active
GROUP BY s.supplier_id, s.name, c.category_id, c.name
HAVING COUNT(p.product_id) >= 2
ORDER BY s.supplier_id, c.category_id;
