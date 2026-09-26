-- Task (Q132): Create or replace a view named vw_delivered_order_totals that returns order_id, customer_id, ordered_at, and item_total for delivered orders. item_total is the sum of quantity multiplied by unit_price across each order's items. Then return every row from vw_delivered_order_totals.
-- Requirement: Order by ordered_at ascending, then order_id ascending.
CREATE OR ALTER VIEW vw_order_financials AS
SELECT o.order_id,
       o.customer_id,
       o.ordered_at,
       o.status,
       SUM(oi.quantity * oi.unit_price) AS item_subtotal,
       o.shipping_fee,
       p.amount AS payment_amount,
       SUM(oi.quantity * oi.unit_price) + o.shipping_fee - p.amount
           AS financial_discrepancy
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN payments AS p ON p.order_id = o.order_id
GROUP BY o.order_id, o.customer_id, o.ordered_at, o.status, o.shipping_fee, p.amount;

SELECT order_id,
       customer_id,
       ordered_at,
       status,
       item_subtotal,
       shipping_fee,
       payment_amount,
       financial_discrepancy
FROM vw_order_financials
ORDER BY order_id;
