-- Task (Q003): Return each warehouse's code as warehouse_code, name as warehouse_name, and capacity_units as capacity.
-- Requirement: Order by warehouse_code ascending.
select w.code as warehouse_code, w.name as warehouse_name,
w.capacity_units as capacity 
from warehouses as w order by warehouse_code
