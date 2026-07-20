-- Task (Q064): Return warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory rows whose quantity_on_hand is the highest in their warehouse. Include every tied highest row.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
select 
    i.warehouse_id,
    w.code as warehouse_code,
    i.product_id,
    p.sku,
    i.quantity_on_hand,
    i.reorder_point
from inventory as i join warehouses as w on i.warehouse_id = w.warehouse_id join products as p on i.product_id=p.product_id
where i.quantity_on_hand = (select max(quantity_on_hand) from inventory as ii where ii.warehouse_id=i.warehouse_id)
order by i.warehouse_id,i.product_id
