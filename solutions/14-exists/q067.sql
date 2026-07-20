-- Task (Q067): Return product_id, sku, and name for active products that have never received a review.
-- Requirement: Order by product_id ascending.
SELECT p.product_id, p.sku, p.name
FROM products AS p
WHERE p.is_active
  AND NOT EXISTS (SELECT 1 FROM reviews AS r WHERE r.product_id = p.product_id)
ORDER BY p.product_id;
