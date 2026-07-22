-- Task (Q070): Return warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory rows that are at or below their reorder point and have no matching store_inventory row with a positive quantity_on_hand for the same product.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
 select 
    i.warehouse_id,
    w.code as warehouse_code,
    i.product_id,
    p.sku,
    i.quantity_on_hand,
    i.reorder_point
from inventory as i join warehouses as w on i.warehouse_id=w.warehouse_id join products as p on i.product_id=p.product_id
where i.quantity_on_hand<=i.reorder_point and not exists (select 1 from store_inventory as si where si.product_id=p.product_id and si.quantity_on_hand>0)
order by warehouse_id,product_id