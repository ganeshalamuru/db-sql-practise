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
