select  shipment_id,order_id,delivered_at,coalesce(delivered_at,shipped_at) as latest_known_event_at
from shipments
order by shipment_id