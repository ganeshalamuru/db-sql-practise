-- Task (Q031): Return status, order_count, and total_shipping_fee: the number of orders and the sum of shipping_fee for each order status.
-- Requirement: Order by total_shipping_fee descending, then status ascending.
select 
    status,
    count(*) as order_count,
    sum(shipping_fee) as total_shipping_fee
from orders
group by status
order by total_shipping_fee desc,status
