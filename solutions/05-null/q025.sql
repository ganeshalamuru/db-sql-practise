-- Task (Q025): Return review_id, product_id, customer_id, rating, and review_text. Replace a NULL review body with the text No written review.
-- Requirement: Order by review_id ascending.
SELECT
    review_id,
    product_id,
    customer_id,
    rating,
    COALESCE(body, 'No written review') AS review_text
FROM reviews
ORDER BY review_id;
