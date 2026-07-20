-- Task (Q078): Return product_id, product_name, category_id, and unit_price for active products that cost more than at least one other active product in the same category.
-- Requirement: Order by category_id ascending, unit_price descending, then product_id ascending.
SELECT p.product_id, p.name AS product_name, p.category_id, p.unit_price
FROM products AS p
WHERE p.is_active
  AND p.unit_price > ANY (
      SELECT peer.unit_price FROM products AS peer
      WHERE peer.is_active AND peer.category_id = p.category_id
        AND peer.product_id <> p.product_id
  )
ORDER BY p.category_id, p.unit_price DESC, p.product_id;
