-- Task (Q073): Return warehouse_id, warehouse_code, product_id, sku, and quantity_on_hand for inventory rows whose product_id appears in at least one return with status requested or approved.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
select 
    i.warehouse_id,
    w.code as warehouse_code,
    i.product_id,
    p.sku,
    i.quantity_on_hand


from inventory as i join warehouses as w on i.warehouse_id=w.warehouse_id join products as p on i.product_id=p.product_id
where i.product_id in (select r.product_id from returns as r where status in ('requested','approved'))
order by i.warehouse_id,i.product_id