select 
    status,
    count(*) as order_count,
    sum(shipping_fee) as total_shipping_fee
from orders
group by status
order by total_shipping_fee desc,status
