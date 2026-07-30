-- Task (Q163): For every supplier, return supplier_id, name, active_product_count, and inactive_product_count. Count active and inactive products with aggregate FILTER clauses, and include suppliers with no products.
-- Requirement: Order by supplier_id ascending.
SELECT s.supplier_id,
       s.name,
       COUNT(p.product_id) FILTER (WHERE p.is_active) AS active_product_count,
       COUNT(p.product_id) FILTER (WHERE NOT p.is_active) AS inactive_product_count
FROM suppliers AS s
LEFT JOIN products AS p ON p.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.name
ORDER BY s.supplier_id;
