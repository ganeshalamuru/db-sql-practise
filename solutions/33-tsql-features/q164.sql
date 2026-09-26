-- Task (Q164): For every active product, return product_id, sku, review_id, rating, and created_at for its most recent review using OUTER APPLY. Include active products with no reviews, using NULL for the review columns.
-- Requirement: Order by product_id ascending.
SELECT p.product_id,
       p.sku,
       r.review_id,
       r.rating,
       r.created_at
FROM products AS p
OUTER APPLY (
    SELECT TOP 1 rev.review_id, rev.rating, rev.created_at
    FROM reviews AS rev
    WHERE rev.product_id = p.product_id
    ORDER BY rev.created_at DESC, rev.review_id DESC
) AS r
WHERE p.is_active = 1
ORDER BY p.product_id;
