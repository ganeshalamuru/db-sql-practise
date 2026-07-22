-- Task (Q144): Update reviews with a NULL body for active products, setting body to 'Review body pending moderation'. Return review_id, product_id, customer_id, and body for each updated review.
-- Requirement: No ordering is required.
UPDATE reviews AS r
SET body = 'Review body pending moderation'
WHERE r.body IS NULL
  AND EXISTS (
      SELECT 1
      FROM products AS p
      WHERE p.product_id = r.product_id
        AND p.is_active
  )
RETURNING r.review_id, r.product_id, r.customer_id, r.body;
