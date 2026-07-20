-- Task (Q033): Return warehouse_id, total_units_on_hand, total_reorder_point, and units_above_reorder. For each warehouse, units_above_reorder is the sum of quantity_on_hand minus reorder_point only for rows where quantity_on_hand is greater than reorder_point; below-reorder rows must not reduce this value.
-- Requirement: Order by units_above_reorder ascending, then warehouse_id ascending.
select 
    warehouse_id,
    sum(quantity_on_hand) as total_units_on_hand,
    sum(reorder_point) as total_reorder_point,
    sum(quantity_on_hand-reorder_point) filter(where quantity_on_hand>reorder_point) as units_above_reorder

from inventory
group by warehouse_id
order by units_above_reorder,warehouse_id
