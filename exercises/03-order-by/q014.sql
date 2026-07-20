select order_id,product_id,quantity,unit_price,(quantity*unit_price) as line_total
from order_items
order by line_total desc,order_id asc