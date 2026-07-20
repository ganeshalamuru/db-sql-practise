-- Task (Q056): Return country_code, country_name, warehouse_code, and warehouse_name for every possible country-and-warehouse combination.
-- Requirement: Order by country_code ascending, then warehouse_code ascending.
select
    c.country_code,
    c.name as country_name,
    w.code as warehouse_code,
    w.name as warehouse_name
from countries as c cross join warehouses as w
order by country_code,warehouse_code
