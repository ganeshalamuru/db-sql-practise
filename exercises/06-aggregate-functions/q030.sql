select 
    min(ordered_at) as first_ordered_at,
    max(ordered_at) as last_ordered_at,
    count(*) as order_count,
    round(avg(shipping_fee),2) as average_shipping_fee
from orders
where ordered_at>='2024-01-01' and ordered_at<'2025-01-01'