-- Task (Q103): Return order_id, order_status, payment_status, shipment_status, and fulfillment_state for every order. fulfillment_state is closed_or_returned when the order is cancelled or the shipment is returned; payment_issue when the payment failed; complete when the order is delivered and the payment completed; and awaiting_fulfillment otherwise.
-- Requirement: Order by order_id ascending.
SELECT o.order_id,
       o.status AS order_status,
       p.status AS payment_status,
       s.status AS shipment_status,
       CASE
           WHEN o.status = 'cancelled' OR s.status = 'returned' THEN 'closed_or_returned'
           WHEN p.status = 'failed' THEN 'payment_issue'
           WHEN o.status = 'delivered' AND p.status = 'completed' THEN 'complete'
           ELSE 'awaiting_fulfillment'
       END AS fulfillment_state
FROM orders AS o
JOIN payments AS p ON p.order_id = o.order_id
JOIN shipments AS s ON s.order_id = o.order_id
ORDER BY o.order_id;
