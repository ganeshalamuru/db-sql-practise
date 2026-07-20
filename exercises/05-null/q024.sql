select order_id,customer_id,ordered_at,status
from orders
where status = 'cancelled' and promotion_id is null