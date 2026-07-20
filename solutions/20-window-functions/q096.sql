-- Task (Q096): Return customer_id, order_id, ordered_at, item_total, and running_delivered_item_total for every delivered order. item_total is the sum of quantity multiplied by unit_price for the order's line items. running_delivered_item_total is the cumulative item_total for that customer through the current delivered order, ordered by ordered_at and then order_id.
-- Requirement: Order by customer_id ascending, ordered_at ascending, then order_id ascending.
WITH delivered_order_totals AS (
    SELECT o.customer_id,
           o.order_id,
           o.ordered_at,
           SUM(oi.quantity * oi.unit_price) AS item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id, o.order_id, o.ordered_at
)
SELECT customer_id,
       order_id,
       ordered_at,
       item_total,
       SUM(item_total) OVER (
           PARTITION BY customer_id
           ORDER BY ordered_at, order_id
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_delivered_item_total
FROM delivered_order_totals
ORDER BY customer_id, ordered_at, order_id;
