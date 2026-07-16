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
