-- Task (Q048): Return supplier_id, supplier_name, and active_product_count for every supplier, including suppliers with no active products.
-- Requirement: Order by active_product_count descending, then supplier_id ascending.
SELECT s.supplier_id, s.name AS supplier_name, COUNT(p.product_id) AS active_product_count
FROM suppliers AS s
LEFT JOIN products AS p
    ON p.supplier_id = s.supplier_id
   AND p.is_active
GROUP BY s.supplier_id, s.name
ORDER BY active_product_count DESC, s.supplier_id;
