-- Task (Q061): Return product_id, sku, name, and unit_price for active products priced above the average unit_price of all active products.
-- Requirement: Order by unit_price descending, then product_id ascending.
select
    p.product_id,
    p.sku,
    p.name,
    p.unit_price

from products as p
where p.is_active and p.unit_price > (select avg(unit_price) from products where products.is_active)
order by unit_price desc,product_id
