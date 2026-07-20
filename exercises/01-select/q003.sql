select w.code as warehouse_code, w.name as warehouse_name,
w.capacity_units as capacity 
from warehouses as w order by warehouse_code