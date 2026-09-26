-- Task (Q146): Delete every review whose body is NULL. Return review_id, product_id, and customer_id for each deleted review.
-- Requirement: No ordering is required.
DELETE FROM reviews
OUTPUT deleted.review_id, deleted.product_id, deleted.customer_id
WHERE body IS NULL;
