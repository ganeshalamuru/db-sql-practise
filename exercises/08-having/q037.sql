select 
    warehouse_id,
    sum(quantity_on_hand) as total_units_on_hand
from inventory
group by warehouse_id
having sum(quantity_on_hand)>50000
order by total_units_on_hand desc,warehouse_id