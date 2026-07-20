select
    customer_id,
    count(*) as order_count,
    min(ordered_at) as first_ordered_at,
    max(ordered_at) as last_ordered_at
from orders
group by customer_id
order by order_count desc,customer_id