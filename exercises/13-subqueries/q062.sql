-- Task (Q062): Return product_id, product_name, category_id, and unit_price for active products priced above the average unit_price of active products in the same category.
-- Requirement: Order by category_id ascending, unit_price descending, then product_id ascending.
select 
    p.product_id,
    p.name as product_name,
    p.category_id,
    p.unit_price
from products as p
where p.is_active and p.unit_price > (select avg(p2.unit_price) from products as p2 where p2.is_active and p2.category_id=p.category_id) 
order by category_id,unit_price desc,product_id
