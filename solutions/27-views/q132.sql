-- Task (Q132): Create or replace a view named vw_delivered_order_totals that returns order_id, customer_id, ordered_at, and item_total for delivered orders. item_total is the sum of quantity multiplied by unit_price across each order's items. Then return every row from vw_delivered_order_totals.
-- Requirement: Order by ordered_at ascending, then order_id ascending.
CREATE OR REPLACE VIEW vw_delivered_order_totals AS
SELECT o.order_id,
       o.customer_id,
       o.ordered_at,
       SUM(oi.quantity * oi.unit_price) AS item_total
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
WHERE o.status = 'delivered'
GROUP BY o.order_id, o.customer_id, o.ordered_at;

SELECT order_id,
       customer_id,
       ordered_at,
       item_total
FROM vw_delivered_order_totals
ORDER BY ordered_at, order_id;
