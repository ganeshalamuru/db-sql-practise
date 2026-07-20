-- Task (Q028): Return total_units_on_hand, total_reorder_point, and units_above_reorder across all inventory rows. units_above_reorder is the sum of quantity_on_hand minus reorder_point only for rows where quantity_on_hand is greater than reorder_point; do not let below-reorder rows reduce this value.
-- Requirement: The result has one row; no ordering is needed.
select 
    sum(quantity_on_hand) as total_units_on_hand,
    sum(reorder_point) as total_reorder_point,
    sum(quantity_on_hand-reorder_point) FILTER(where quantity_on_hand>reorder_point) as units_above_reorder
from inventory
