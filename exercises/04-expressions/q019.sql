select product_id,name,unit_price,(unit_price>=1000) as is_premium
from products
order by product_id