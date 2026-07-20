-- Task (Q017): Return warehouse_id, product_id, quantity_on_hand, reorder_point, and units_above_reorder (quantity_on_hand minus reorder_point) for all inventory rows.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
select warehouse_id,product_id,quantity_on_hand,reorder_point,(quantity_on_hand-reorder_point) as units_above_reorder
from inventory
order by warehouse_id,product_id
