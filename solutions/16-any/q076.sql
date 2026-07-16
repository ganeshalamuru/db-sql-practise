SELECT p.product_id, p.sku, p.name, p.unit_price
FROM products AS p
WHERE p.is_active
  AND p.unit_price > ANY (
      SELECT peer.unit_price FROM products AS peer
      WHERE peer.is_active AND peer.supplier_id = 1
  )
ORDER BY p.unit_price, p.product_id;
