select order_id,customer_id,ordered_at,status
from orders
order by ordered_at desc,order_id desc