SELECT p.product_id,
       p.name AS product_name,
       p.category_id,
       p.unit_price
FROM products AS p
WHERE p.is_active
  AND p.unit_price > (
      SELECT AVG(peer.unit_price)
      FROM products AS peer
      WHERE peer.is_active
        AND peer.category_id = p.category_id
  )
ORDER BY p.category_id, p.unit_price DESC, p.product_id;
