select
    c.country_code,
    c.name as country_name,
    w.code as warehouse_code,
    w.name as warehouse_name
from countries as c cross join warehouses as w
order by country_code,warehouse_code