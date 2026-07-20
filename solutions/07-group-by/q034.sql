-- Task (Q034): Return product_id, review_count, and average_rating for each reviewed product. average_rating must be rounded to two decimal places.
-- Requirement: Order by average_rating descending, then review_count descending, then product_id ascending.
SELECT product_id,
       COUNT(*) AS review_count,
       ROUND(AVG(rating), 2) AS average_rating
FROM reviews
GROUP BY product_id
ORDER BY average_rating DESC, review_count DESC, product_id;
