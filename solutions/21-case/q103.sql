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
