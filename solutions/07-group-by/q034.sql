SELECT product_id,
       COUNT(*) AS review_count,
       ROUND(AVG(rating), 2) AS average_rating
FROM reviews
GROUP BY product_id
ORDER BY average_rating DESC, review_count DESC, product_id;
