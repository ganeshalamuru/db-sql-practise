-- Task (Q163): For every supplier, return supplier_id, name, active_product_count, and inactive_product_count. Count active and inactive products using conditional CASE aggregates, and include suppliers with no products.
-- Requirement: Order by supplier_id ascending.
SELECT s.supplier_id,
       s.name,
       COUNT(CASE WHEN p.is_active = 1 THEN 1 END) AS active_product_count,
       COUNT(CASE WHEN p.is_active = 0 THEN 1 END) AS inactive_product_count
FROM suppliers AS s
LEFT JOIN products AS p ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.name
ORDER BY s.supplier_id;
