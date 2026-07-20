select
    w.warehouse_id,
    w.code as warehouse_code,
    COALESCE(sum(i.quantity_on_hand),0) as total_units_on_hand
from warehouses as w left join inventory as i on w.warehouse_id=i.warehouse_id
group by w.warehouse_id,warehouse_code
order by total_units_on_hand desc,warehouse_id asc 