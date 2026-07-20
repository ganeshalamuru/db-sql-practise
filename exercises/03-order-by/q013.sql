-- Task (Q013): Return order_id, customer_id, ordered_at, and status for all orders.
-- Requirement: Order by ordered_at descending, then order_id descending.
select order_id,customer_id,ordered_at,status
from orders
order by ordered_at desc,order_id desc
