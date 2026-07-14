SELECT
    shipment_id,
    order_id,
    delivered_at,
    COALESCE(delivered_at, shipped_at) AS latest_known_event_at
FROM shipments
ORDER BY shipment_id;
