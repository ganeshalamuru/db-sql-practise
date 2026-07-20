select order_id,customer_id,ordered_at,status
from orders
where status='delivered' 
    and ordered_at>='2024-01-01 00:00:00+05:30' 
    and ordered_at<'2025-01-01 00:00:00+05:30'
order by ordered_at,order_id