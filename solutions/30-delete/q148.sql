-- Task (Q148): Delete reviews written by customers whose status is closed. Return review_id, product_id, and customer_id for each deleted review.
-- Requirement: No ordering is required.
DELETE FROM reviews
WHERE customer_id IN (
    SELECT customer_id
    FROM customers
    WHERE status = 'closed'
)
RETURNING review_id, product_id, customer_id;
