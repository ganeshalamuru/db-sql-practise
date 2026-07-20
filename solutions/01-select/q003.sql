-- Task (Q003): Return each warehouse's code as warehouse_code, name as warehouse_name, and capacity_units as capacity.
-- Requirement: Order by warehouse_code ascending.
SELECT code AS warehouse_code, name AS warehouse_name, capacity_units AS capacity
FROM warehouses
ORDER BY warehouse_code;
