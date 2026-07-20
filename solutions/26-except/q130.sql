-- Task (Q130): Return order_id, customer_id, ordered_at, order_status, payment_status, and item_total for orders whose payment status is not completed. item_total is the sum of quantity multiplied by unit_price across each order's line items.
-- Requirement: Order by ordered_at ascending, then order_id ascending.
WITH unsettled_order_ids AS (
    SELECT order_id FROM orders
    EXCEPT
    SELECT order_id FROM payments WHERE status = 'completed'
), order_totals AS (
    SELECT order_id,
           SUM(quantity * unit_price) AS item_total
    FROM order_items
    GROUP BY order_id
)
SELECT o.order_id,
       o.customer_id,
       o.ordered_at,
       o.status AS order_status,
       p.status AS payment_status,
       t.item_total
FROM unsettled_order_ids AS u
JOIN orders AS o ON o.order_id = u.order_id
JOIN payments AS p ON p.order_id = u.order_id
JOIN order_totals AS t ON t.order_id = u.order_id
ORDER BY o.ordered_at, o.order_id;
