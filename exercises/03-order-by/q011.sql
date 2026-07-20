select product_id,name,unit_price
from products
where is_active=true
order by unit_price desc,product_id