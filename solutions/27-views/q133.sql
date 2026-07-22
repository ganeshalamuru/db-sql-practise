-- Task (Q133): Create or replace a view named vw_product_review_summary that returns product_id, sku, review_count, and average_rating for products with at least one review. average_rating is the average review rating. Then return every row from vw_product_review_summary.
-- Requirement: Order by review_count descending, then product_id ascending.
CREATE OR REPLACE VIEW vw_product_review_summary AS
SELECT p.product_id,
       p.sku,
       COUNT(r.review_id) AS review_count,
       AVG(r.rating) AS average_rating
FROM products AS p
JOIN reviews AS r ON r.product_id = p.product_id
GROUP BY p.product_id, p.sku;

SELECT product_id,
       sku,
       review_count,
       average_rating
FROM vw_product_review_summary
ORDER BY review_count DESC, product_id;
