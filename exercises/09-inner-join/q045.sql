-- Task (Q045): Return shipment_id, shipment_status, warehouse_code, warehouse_name, city_name, and country_name for delivered shipments.
-- Requirement: Order by country_name ascending, city_name ascending, warehouse_code ascending, then shipment_id ascending.
select
    shipment_id,
    s.status as shipment_status,
    w.code as warehouse_code,
    w.name as warehouse_name,
    cty.name as city_name,
    cnt.name as country_name

from shipments as s join warehouses as w on s.warehouse_id=w.warehouse_id
join cities as cty on cty.city_id = w.city_id join countries as cnt on cty.country_id=cnt.country_id

where s.status = 'delivered'
order by country_name,city_name,warehouse_code,shipment_id


