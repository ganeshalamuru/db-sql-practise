SELECT shipment_id, order_id, shipped_at, delivered_at
FROM shipments
WHERE delivered_at IS NOT NULL
ORDER BY shipment_id;
