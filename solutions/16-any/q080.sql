-- Task (Q080): Return supplier_id, supplier_name, and active_product_count for suppliers with at least two active products, where at least one active product costs more than any active product in category_id 1.
-- Requirement: Order by active_product_count descending, then supplier_id ascending.
SELECT s.supplier_id, s.name AS supplier_name, COUNT(p.product_id) AS active_product_count
FROM suppliers AS s
JOIN products AS p ON p.supplier_id = s.supplier_id AND p.is_active
GROUP BY s.supplier_id, s.name
HAVING COUNT(p.product_id) >= 2
   AND MAX(p.unit_price) > ANY (
       SELECT peer.unit_price FROM products AS peer
       WHERE peer.is_active AND peer.category_id = 1
   )
ORDER BY active_product_count DESC, s.supplier_id;
