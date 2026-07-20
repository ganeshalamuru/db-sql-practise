-- Task (Q022): Return shipment_id, order_id, shipped_at, and delivered_at for shipments that have been delivered.
-- Requirement: Order by shipment_id ascending.
select shipment_id,order_id,shipped_at,delivered_at
from shipments
where delivered_at is not NULL
order by shipment_id
