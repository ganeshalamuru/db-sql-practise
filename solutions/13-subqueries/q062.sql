-- Task (Q062): Return product_id, product_name, category_id, and unit_price for active products priced above the average unit_price of active products in the same category.
-- Requirement: Order by category_id ascending, unit_price descending, then product_id ascending.
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
