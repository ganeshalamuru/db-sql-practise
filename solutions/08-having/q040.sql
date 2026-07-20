-- Task (Q040): Return product_id, review_count, and average_rating for products that have at least 5 reviews and an average review rating of at least 4.00. Round average_rating to two decimal places.
-- Requirement: Order by average_rating descending, then review_count descending, then product_id ascending.
SELECT product_id, COUNT(*) AS review_count, ROUND(AVG(rating), 2) AS average_rating
FROM reviews
GROUP BY product_id
HAVING COUNT(*) >= 5
   AND AVG(rating) >= 4.00
ORDER BY average_rating DESC, review_count DESC, product_id;
