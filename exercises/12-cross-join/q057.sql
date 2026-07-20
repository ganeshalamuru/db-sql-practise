-- Task (Q057): Return store_id, store_code, warehouse_id, and warehouse_code for every store-and-warehouse pair located in different cities.
-- Requirement: Order by store_id ascending, then warehouse_id ascending.
select 
    s.store_id,
    s.code as store_code,
    w.warehouse_id,
    w.code as warehouse_code
from stores as s cross join warehouses as w
where s.city_id != w.city_id
