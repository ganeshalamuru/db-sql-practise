-- Task (Q138): Insert a review for product_id 100 and customer_id 1 with rating 5, body 'Excellent practice product', and created_at '2024-02-01 12:30:00+00'. Return product_id, customer_id, rating, body, and created_at for the inserted review.
-- Requirement: No ordering is required.
INSERT INTO reviews (product_id, customer_id, rating, body, created_at)
VALUES (100, 1, 5, 'Excellent practice product', '2024-02-01 12:30:00+00')
RETURNING product_id, customer_id, rating, body, created_at;
