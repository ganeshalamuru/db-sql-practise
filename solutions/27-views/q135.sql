-- Task (Q135): Create or replace a view named vw_customer_activity that returns customer_id, email, order_count, delivered_item_total, review_count, and last_activity_at for every customer with at least one order or review. delivered_item_total is the sum of quantity multiplied by unit_price in delivered orders and is 0 for a customer with no delivered items. last_activity_at is the latest ordered_at or review created_at timestamp. Then return every row from vw_customer_activity.
-- Requirement: Order by last_activity_at descending, then customer_id ascending.
CREATE OR REPLACE VIEW vw_customer_activity AS
WITH order_totals AS (
    SELECT o.order_id,
           o.customer_id,
           o.status,
           o.ordered_at,
           SUM(oi.quantity * oi.unit_price) AS item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    GROUP BY o.order_id, o.customer_id, o.status, o.ordered_at
), order_metrics AS (
    SELECT customer_id,
           COUNT(*) AS order_count,
           COALESCE(SUM(item_total) FILTER (WHERE status = 'delivered'), 0) AS delivered_item_total,
           MAX(ordered_at) AS last_ordered_at
    FROM order_totals
    GROUP BY customer_id
), review_metrics AS (
    SELECT customer_id,
           COUNT(*) AS review_count,
           MAX(created_at) AS last_reviewed_at
    FROM reviews
    GROUP BY customer_id
)
SELECT c.customer_id,
       c.email,
       COALESCE(om.order_count, 0) AS order_count,
       COALESCE(om.delivered_item_total, 0) AS delivered_item_total,
       COALESCE(rm.review_count, 0) AS review_count,
       CASE
           WHEN om.last_ordered_at IS NULL THEN rm.last_reviewed_at
           WHEN rm.last_reviewed_at IS NULL THEN om.last_ordered_at
           ELSE GREATEST(om.last_ordered_at, rm.last_reviewed_at)
       END AS last_activity_at
FROM customers AS c
LEFT JOIN order_metrics AS om ON om.customer_id = c.customer_id
LEFT JOIN review_metrics AS rm ON rm.customer_id = c.customer_id
WHERE om.customer_id IS NOT NULL
   OR rm.customer_id IS NOT NULL;

SELECT customer_id,
       email,
       order_count,
       delivered_item_total,
       review_count,
       last_activity_at
FROM vw_customer_activity
ORDER BY last_activity_at DESC, customer_id;
