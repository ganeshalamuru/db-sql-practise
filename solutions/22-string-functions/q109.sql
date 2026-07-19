SELECT p.product_id,
       p.sku,
       COUNT(r.review_id) AS review_count,
       STRING_AGG(c.email, ', ' ORDER BY c.email) AS reviewer_email_list,
       STRING_AGG(
           COALESCE(r.body, '(no text)'),
           ' | ' ORDER BY r.created_at, r.review_id
       ) AS review_text_summary
FROM products AS p
JOIN reviews AS r ON r.product_id = p.product_id
JOIN customers AS c ON c.customer_id = r.customer_id
GROUP BY p.product_id, p.sku
HAVING COUNT(r.review_id) >= 2
ORDER BY review_count DESC, p.product_id;
