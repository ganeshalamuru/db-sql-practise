select product_id,sku,unit_price,(unit_price*100) as price_in_cents
from products
order by product_id