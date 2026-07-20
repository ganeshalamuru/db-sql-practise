-- Task (Q044): Return review_id, product_name, customer_id, customer_first_name, customer_last_name, rating, and created_at for reviews with a rating of 4 or 5.
-- Requirement: Order by created_at descending, then review_id descending.
SELECT r.review_id,
       p.name AS product_name,
       c.customer_id,
       c.first_name AS customer_first_name,
       c.last_name AS customer_last_name,
       r.rating,
       r.created_at
FROM reviews AS r
JOIN products AS p ON p.product_id = r.product_id
JOIN customers AS c ON c.customer_id = r.customer_id
WHERE r.rating >= 4
ORDER BY r.created_at DESC, r.review_id DESC;
