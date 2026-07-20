WITH ordering_customer_ids AS (
    SELECT customer_id FROM orders
), reviewing_customer_ids AS (
    SELECT customer_id FROM reviews
), qualifying_customer_ids AS (
    SELECT customer_id FROM ordering_customer_ids
    EXCEPT
    SELECT customer_id FROM reviewing_customer_ids
), order_metrics AS (
    SELECT customer_id,
           COUNT(order_id) AS order_count,
           MAX(ordered_at) AS last_ordered_at
    FROM orders
    GROUP BY customer_id
)
SELECT c.customer_id,
       c.email,
       o.order_count,
       o.last_ordered_at
FROM qualifying_customer_ids AS q
JOIN customers AS c ON c.customer_id = q.customer_id
JOIN order_metrics AS o ON o.customer_id = q.customer_id
ORDER BY o.last_ordered_at DESC, c.customer_id;
