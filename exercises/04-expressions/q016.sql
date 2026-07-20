select order_id,product_id,quantity,unit_price,(quantity*unit_price) as line_total
from order_items
order by order_id,product_id