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
