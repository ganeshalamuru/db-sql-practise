-- Task (Q023): Return shipment_id, order_id, delivered_at, and latest_known_event_at. Use delivered_at when available; otherwise use shipped_at.
-- Requirement: Order by shipment_id ascending.
select  shipment_id,order_id,delivered_at,coalesce(delivered_at,shipped_at) as latest_known_event_at
from shipments
order by shipment_id
