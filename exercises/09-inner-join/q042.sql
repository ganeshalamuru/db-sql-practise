-- Task (Q042): Return order_id, ordered_at, status, customer_id, customer_first_name, and customer_last_name for delivered orders.
-- Requirement: Order by ordered_at descending, then order_id descending.
select 
    order_id,
    ordered_at,
    o.status,
    o.customer_id as customer_id,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name
from orders as o join customers as c on o.customer_id = c.customer_id
where o.status = 'delivered'
order by ordered_at desc,order_id desc
