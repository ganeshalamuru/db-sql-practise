select shipment_id,order_id,shipped_at,delivered_at
from shipments
where delivered_at is not NULL
order by shipment_id