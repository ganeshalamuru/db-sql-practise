-- Task (Q081): Return product_id, sku, name, and unit_price for active products priced higher than every active product supplied by supplier_id 1.
-- Requirement: Order by unit_price ascending, then product_id ascending.
SELECT p.product_id, p.sku, p.name, p.unit_price
FROM products AS p
WHERE p.is_active
  AND p.unit_price > ALL (
      SELECT peer.unit_price FROM products AS peer
      WHERE peer.is_active AND peer.supplier_id = 1
  )
ORDER BY p.unit_price, p.product_id;
