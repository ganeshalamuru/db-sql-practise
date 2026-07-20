-- Task (Q109): Return product_id, sku, review_count, reviewer_email_list, and review_text_summary for products with at least two reviews. reviewer_email_list contains reviewer emails separated by ', ' and sorted by email ascending. review_text_summary contains each review body, using '(no text)' for NULL bodies, separated by ' | ' and sorted by created_at ascending and then review_id ascending.
-- Requirement: Order by review_count descending, then product_id ascending.
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
