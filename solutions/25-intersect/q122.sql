-- Task (Q122): Return customer_id, email, order_count, review_count, last_ordered_at, and last_reviewed_at for customers who have both placed at least one order and submitted at least one review.
-- Requirement: Order by customer_id ascending.
WITH ordered_customers AS (
    SELECT customer_id FROM orders
), reviewed_customers AS (
    SELECT customer_id FROM reviews
), qualifying_customer_ids AS (
    SELECT customer_id FROM ordered_customers
    INTERSECT
    SELECT customer_id FROM reviewed_customers
), order_metrics AS (
    SELECT customer_id,
           COUNT(order_id) AS order_count,
           MAX(ordered_at) AS last_ordered_at
    FROM orders
    GROUP BY customer_id
), review_metrics AS (
    SELECT customer_id,
           COUNT(review_id) AS review_count,
           MAX(created_at) AS last_reviewed_at
    FROM reviews
    GROUP BY customer_id
)
SELECT c.customer_id,
       c.email,
       o.order_count,
       r.review_count,
       o.last_ordered_at,
       r.last_reviewed_at
FROM qualifying_customer_ids AS q
JOIN customers AS c ON c.customer_id = q.customer_id
JOIN order_metrics AS o ON o.customer_id = q.customer_id
JOIN review_metrics AS r ON r.customer_id = q.customer_id
ORDER BY c.customer_id;
