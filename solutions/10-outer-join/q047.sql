-- Task (Q047): Return product_id, product_name, and review_count for every active product, including products with no reviews.
-- Requirement: Order by review_count descending, then product_id ascending.
SELECT p.product_id, p.name AS product_name, COUNT(r.review_id) AS review_count
FROM products AS p
LEFT JOIN reviews AS r ON r.product_id = p.product_id
WHERE p.is_active
GROUP BY p.product_id, p.name
ORDER BY review_count DESC, p.product_id;
