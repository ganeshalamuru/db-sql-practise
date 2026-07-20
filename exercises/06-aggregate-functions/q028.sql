select 
    sum(quantity_on_hand) as total_units_on_hand,
    sum(reorder_point) as total_reorder_point,
    sum(quantity_on_hand-reorder_point) FILTER(where quantity_on_hand>reorder_point) as units_above_reorder
from inventory