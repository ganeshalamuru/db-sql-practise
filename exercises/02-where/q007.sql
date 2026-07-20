select product_id,sku,name,unit_price 
from products 
where is_active=true and unit_price>1000
order by unit_price,product_id