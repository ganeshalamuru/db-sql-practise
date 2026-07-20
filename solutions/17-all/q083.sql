-- Task (Q083): Return product_id, product_name, category_id, and unit_price for active products whose unit_price is at least as high as every other active product in the same category. Include ties.
-- Requirement: Order by category_id ascending, then product_id ascending.
SELECT p.product_id, p.name AS product_name, p.category_id, p.unit_price
FROM products AS p
WHERE p.is_active
  AND p.unit_price >= ALL (
      SELECT peer.unit_price FROM products AS peer
      WHERE peer.is_active AND peer.category_id = p.category_id
  )
ORDER BY p.category_id, p.product_id;
