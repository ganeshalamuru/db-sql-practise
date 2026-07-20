-- Task (Q007): Return product_id, sku, name, and unit_price for active products priced above 1,000.00.
-- Requirement: Order by unit_price ascending, then product_id ascending.
select product_id,sku,name,unit_price 
from products 
where is_active=true and unit_price>1000
order by unit_price,product_id
