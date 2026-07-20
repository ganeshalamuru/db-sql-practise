-- Task (Q010): Return warehouse_id, product_id, quantity_on_hand, and reorder_point for inventory rows at or below their reorder point.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
select warehouse_id,product_id,quantity_on_hand,reorder_point
from inventory
where quantity_on_hand<=reorder_point
order by warehouse_id,product_id
