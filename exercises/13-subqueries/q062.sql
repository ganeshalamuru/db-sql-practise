select 
    p.product_id,
    p.name as product_name,
    p.category_id,
    p.unit_price
from products as p
where p.is_active and p.unit_price > (select avg(p2.unit_price) from products as p2 where p2.is_active and p2.category_id=p.category_id) 
order by category_id,unit_price desc,product_id