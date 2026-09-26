-- Task (Q144): Update reviews with a NULL body for active products, setting body to 'Review body pending moderation'. Return review_id, product_id, customer_id, and body for each updated review.
-- Requirement: No ordering is required.
UPDATE reviews
SET body = 'Review body pending moderation'
OUTPUT inserted.review_id, inserted.product_id, inserted.customer_id, inserted.body
WHERE body IS NULL
  AND EXISTS (
      SELECT 1
      FROM products AS p
      WHERE p.product_id = reviews.product_id
        AND p.is_active = 1
  );
