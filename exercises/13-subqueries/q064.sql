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
