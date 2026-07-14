SELECT
    review_id,
    product_id,
    customer_id,
    rating,
    COALESCE(body, 'No written review') AS review_text
FROM reviews
ORDER BY review_id;
