select 
    warehouse_id,
    sum(quantity_on_hand) as total_units_on_hand,
    sum(reorder_point) as total_reorder_point,
    sum(quantity_on_hand-reorder_point) filter(where quantity_on_hand>reorder_point) as units_above_reorder

from inventory
group by warehouse_id
order by units_above_reorder,warehouse_id