-- Task (Q148): Delete reviews written by customers whose status is closed. Return review_id, product_id, and customer_id for each deleted review.
-- Requirement: No ordering is required.
DELETE FROM reviews
OUTPUT deleted.review_id, deleted.product_id, deleted.customer_id
WHERE customer_id IN (
    SELECT customer_id
    FROM customers
    WHERE status = 'closed'
);
