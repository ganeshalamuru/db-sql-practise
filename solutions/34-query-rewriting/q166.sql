-- Task (Q166): Using EXISTS, return product_id, sku, and name for active products that have at least one five-star review.
-- Requirement: Order by product_id ascending.
SELECT p.product_id,
       p.sku,
       p.name
FROM products AS p
WHERE p.is_active
  AND EXISTS (
      SELECT 1
      FROM reviews AS r
      WHERE r.product_id = p.product_id
        AND r.rating = 5
  )
ORDER BY p.product_id;
