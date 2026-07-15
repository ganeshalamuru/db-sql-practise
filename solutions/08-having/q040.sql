SELECT product_id, COUNT(*) AS review_count, ROUND(AVG(rating), 2) AS average_rating
FROM reviews
GROUP BY product_id
HAVING COUNT(*) >= 5
   AND AVG(rating) >= 4.00
ORDER BY average_rating DESC, review_count DESC, product_id;
