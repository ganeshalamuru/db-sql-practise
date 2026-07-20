-- Task (Q121): Return product_id, sku, delivered_order_count, and review_count for active products that both appear in at least one delivered order and have at least one review. delivered_order_count is the number of distinct delivered orders containing the product.
-- Requirement: Order by delivered_order_count descending, review_count descending, then product_id ascending.
WITH delivered_product_sales AS (
    SELECT oi.product_id,
           COUNT(DISTINCT o.order_id) AS delivered_order_count
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY oi.product_id
), product_reviews AS (
    SELECT r.product_id,
           COUNT(r.review_id) AS review_count
    FROM reviews AS r
    GROUP BY r.product_id
), qualifying_product_ids AS (
    SELECT product_id FROM delivered_product_sales
    INTERSECT
    SELECT product_id FROM product_reviews
)
SELECT p.product_id,
       p.sku,
       s.delivered_order_count,
       r.review_count
FROM qualifying_product_ids AS q
JOIN products AS p ON p.product_id = q.product_id
JOIN delivered_product_sales AS s ON s.product_id = q.product_id
JOIN product_reviews AS r ON r.product_id = q.product_id
WHERE p.is_active
ORDER BY s.delivered_order_count DESC, r.review_count DESC, p.product_id;
