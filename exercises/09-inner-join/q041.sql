select 
    product_id,
    p.name as product_name,
    s.name as supplier_name,
    unit_price
from products as p join suppliers as s on p.supplier_id = s.supplier_id
where p.is_active = true 
order by supplier_name,product_name,product_id
