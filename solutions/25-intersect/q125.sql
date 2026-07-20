WITH completed_payment_order_ids AS (
    SELECT order_id
    FROM payments
    WHERE status = 'completed'
), delivered_shipment_order_ids AS (
    SELECT order_id
    FROM shipments
    WHERE status = 'delivered'
), qualifying_order_ids AS (
    SELECT order_id FROM completed_payment_order_ids
    INTERSECT
    SELECT order_id FROM delivered_shipment_order_ids
), order_totals AS (
    SELECT order_id,
           SUM(quantity * unit_price) AS item_total
    FROM order_items
    GROUP BY order_id
)
SELECT o.order_id,
       o.customer_id,
       o.ordered_at,
       p.amount AS payment_amount,
       t.item_total,
       s.delivered_at
FROM qualifying_order_ids AS q
JOIN orders AS o ON o.order_id = q.order_id
JOIN payments AS p ON p.order_id = q.order_id
JOIN shipments AS s ON s.order_id = q.order_id
JOIN order_totals AS t ON t.order_id = q.order_id
ORDER BY o.ordered_at, o.order_id;
