-- Task (Q059): Return warehouse_id, warehouse_code, product_id, sku, and unit_price for every warehouse-and-product combination where the product is active and priced at least 1,000.00.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
select 
    w.warehouse_id,
    w.code as warehouse_code,
    p.product_id,
    p.sku,
    p.unit_price

from warehouses as w cross join products as p
where p.is_active and p.unit_price>=1000
order by warehouse_id,product_id
