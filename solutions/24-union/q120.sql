-- Task (Q120): Return customer_id, email, order_count, review_count, and last_activity_at for every customer with at least one order or review. order_count counts orders, review_count counts reviews, and last_activity_at is the latest ordered_at or review created_at timestamp for that customer.
-- Requirement: Order by last_activity_at descending, then customer_id ascending.
WITH customer_events AS (
    SELECT o.customer_id,
           'order'::TEXT AS event_type,
           o.ordered_at AS occurred_at
    FROM orders AS o

    UNION ALL

    SELECT r.customer_id,
           'review'::TEXT AS event_type,
           r.created_at AS occurred_at
    FROM reviews AS r
)
SELECT c.customer_id,
       c.email,
       COUNT(*) FILTER (WHERE e.event_type = 'order') AS order_count,
       COUNT(*) FILTER (WHERE e.event_type = 'review') AS review_count,
       MAX(e.occurred_at) AS last_activity_at
FROM customer_events AS e
JOIN customers AS c ON c.customer_id = e.customer_id
GROUP BY c.customer_id, c.email
ORDER BY last_activity_at DESC, c.customer_id;
