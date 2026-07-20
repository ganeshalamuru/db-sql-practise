-- Task (Q068): Return supplier_id, supplier_name, product_id, product_name, and unit_price for active products from suppliers that also supply at least one other active product priced above 1,000.00.
-- Requirement: Order by supplier_id ascending, then product_id ascending.
SELECT s.supplier_id, s.name AS supplier_name, p.product_id, p.name AS product_name, p.unit_price
FROM suppliers AS s
JOIN products AS p ON p.supplier_id = s.supplier_id
WHERE p.is_active
  AND EXISTS (
      SELECT 1 FROM products AS peer
      WHERE peer.supplier_id = s.supplier_id AND peer.is_active
        AND peer.product_id <> p.product_id AND peer.unit_price > 1000.00
  )
ORDER BY s.supplier_id, p.product_id;
