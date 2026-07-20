-- Task (Q011): Return product_id, name, and unit_price for active products.
-- Requirement: Order by unit_price descending, then product_id ascending.
select product_id,name,unit_price
from products
where is_active=true
order by unit_price desc,product_id
