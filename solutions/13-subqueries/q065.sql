-- Task (Q065): Return supplier_id, supplier_name, product_id, product_name, and unit_price for active products whose unit_price is greater than the average unit_price of that supplier's active products. Include only suppliers that have at least two active products.
-- Requirement: Order by supplier_id ascending, unit_price descending, then product_id ascending.
SELECT s.supplier_id,
       s.name AS supplier_name,
       p.product_id,
       p.name AS product_name,
       p.unit_price
FROM suppliers AS s
JOIN products AS p ON p.supplier_id = s.supplier_id
WHERE p.is_active
  AND p.unit_price > (
      SELECT AVG(peer.unit_price)
      FROM products AS peer
      WHERE peer.supplier_id = s.supplier_id
        AND peer.is_active
  )
  AND 2 <= (
      SELECT COUNT(*)
      FROM products AS peer
      WHERE peer.supplier_id = s.supplier_id
        AND peer.is_active
  )
ORDER BY s.supplier_id, p.unit_price DESC, p.product_id;
