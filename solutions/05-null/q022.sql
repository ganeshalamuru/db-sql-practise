-- Task (Q022): Return shipment_id, order_id, shipped_at, and delivered_at for shipments that have been delivered.
-- Requirement: Order by shipment_id ascending.
SELECT shipment_id, order_id, shipped_at, delivered_at
FROM shipments
WHERE delivered_at IS NOT NULL
ORDER BY shipment_id;
