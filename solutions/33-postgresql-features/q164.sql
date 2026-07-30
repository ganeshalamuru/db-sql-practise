-- Task (Q164): For every active product, return product_id, sku, review_id, rating, and created_at for its most recent review. Include active products with no reviews, using NULL for the review columns.
-- Requirement: Order by product_id ascending.
SELECT p.product_id,
       p.sku,
       latest_review.review_id,
       latest_review.rating,
       latest_review.created_at
FROM products AS p
LEFT JOIN LATERAL (
    SELECT r.review_id,
           r.rating,
           r.created_at
    FROM reviews AS r
    WHERE r.product_id = p.product_id
    ORDER BY r.created_at DESC, r.review_id DESC
    LIMIT 1
) AS latest_review ON true
WHERE p.is_active
ORDER BY p.product_id;
