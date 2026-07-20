-- Task (Q118): Return order_id, product_id, sku, event_type, event_date, and quantity for two event types: delivered_sale for every order item in a delivered order, using the order date; and processed_return for every return with status approved or received, using the requested date. Include every event occurrence, even when values repeat.
-- Requirement: Order by event_date ascending, event_type ascending, order_id ascending, then product_id ascending.
SELECT o.order_id,
       p.product_id,
       p.sku,
       'delivered_sale'::TEXT AS event_type,
       o.ordered_at::DATE AS event_date,
       oi.quantity
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
WHERE o.status = 'delivered'

UNION ALL

SELECT r.order_id,
       p.product_id,
       p.sku,
       'processed_return'::TEXT AS event_type,
       r.requested_at::DATE AS event_date,
       r.quantity
FROM returns AS r
JOIN products AS p ON p.product_id = r.product_id
WHERE r.status IN ('approved', 'received')

ORDER BY event_date, event_type, order_id, product_id;
