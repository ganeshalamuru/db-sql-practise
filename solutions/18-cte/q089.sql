-- Task (Q089): Return category_id, category_name, active_product_count, and average_rating for categories with at least two active products and at least one review. average_rating is the average rating across reviews of active products in the category.
-- Requirement: Order by average_rating descending, then category_id ascending.
WITH active_products AS (
    SELECT product_id, category_id FROM products WHERE is_active
), category_product_counts AS (
    SELECT category_id, COUNT(*) AS active_product_count
    FROM active_products
    GROUP BY category_id
), category_ratings AS (
    SELECT ap.category_id, AVG(r.rating) AS average_rating
    FROM active_products AS ap
    JOIN reviews AS r ON r.product_id = ap.product_id
    GROUP BY ap.category_id
)
SELECT c.category_id, c.name AS category_name,
       pc.active_product_count, cr.average_rating
FROM categories AS c
JOIN category_product_counts AS pc ON pc.category_id = c.category_id
JOIN category_ratings AS cr ON cr.category_id = c.category_id
WHERE pc.active_product_count >= 2
ORDER BY cr.average_rating DESC, c.category_id;
