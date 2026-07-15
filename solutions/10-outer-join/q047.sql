SELECT p.product_id, p.name AS product_name, COUNT(r.review_id) AS review_count
FROM products AS p
LEFT JOIN reviews AS r ON r.product_id = p.product_id
WHERE p.is_active
GROUP BY p.product_id, p.name
ORDER BY review_count DESC, p.product_id;
