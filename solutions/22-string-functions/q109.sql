-- Task (Q109): Return product_id, sku, review_count, reviewer_email_list, and review_text_summary for products with at least two reviews. reviewer_email_list contains reviewer emails separated by ', ' and sorted by email ascending. review_text_summary contains each review body, using '(no text)' for NULL bodies, separated by ' | ' and sorted by created_at ascending and then review_id ascending.
-- Requirement: Order by review_count descending, then product_id ascending.
WITH product_review_counts AS (
    SELECT p.product_id,
           p.sku,
           COUNT(r.review_id) AS review_count
    FROM products AS p
    JOIN reviews AS r ON r.product_id = p.product_id
    GROUP BY p.product_id, p.sku
    HAVING COUNT(r.review_id) >= 2
), reviewer_emails AS (
    SELECT p.product_id,
           STRING_AGG(c.email, ', ') WITHIN GROUP (ORDER BY c.email) AS reviewer_email_list
    FROM products AS p
    JOIN reviews AS r ON r.product_id = p.product_id
    JOIN customers AS c ON c.customer_id = r.customer_id
    GROUP BY p.product_id
), review_summaries AS (
    SELECT p.product_id,
           STRING_AGG(COALESCE(r.body, '(no text)'), ' | ') WITHIN GROUP (ORDER BY r.created_at, r.review_id) AS review_text_summary
    FROM products AS p
    JOIN reviews AS r ON r.product_id = p.product_id
    GROUP BY p.product_id
)
SELECT prc.product_id,
       prc.sku,
       prc.review_count,
       re.reviewer_email_list,
       rs.review_text_summary
FROM product_review_counts AS prc
JOIN reviewer_emails AS re ON re.product_id = prc.product_id
JOIN review_summaries AS rs ON rs.product_id = prc.product_id
ORDER BY prc.review_count DESC, prc.product_id;
