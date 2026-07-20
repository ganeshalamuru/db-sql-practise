select 
    w.warehouse_id,
    w.code as warehouse_code,
    p.product_id,
    p.sku,
    p.unit_price

from warehouses as w cross join products as p
where p.is_active and p.unit_price>=1000
order by warehouse_id,product_id