select 
    s.store_id,
    s.code as store_code,
    w.warehouse_id,
    w.code as warehouse_code
from stores as s cross join warehouses as w
where s.city_id != w.city_id