-- Task (Q023): Return shipment_id, order_id, delivered_at, and latest_known_event_at. Use delivered_at when available; otherwise use shipped_at.
-- Requirement: Order by shipment_id ascending.
SELECT
    shipment_id,
    order_id,
    delivered_at,
    COALESCE(delivered_at, shipped_at) AS latest_known_event_at
FROM shipments
ORDER BY shipment_id;
