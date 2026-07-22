-- Task (Q069): Return order_id, ordered_at, customer_id, customer_first_name, customer_last_name, and status for orders that contain at least one product with a unit_price of 1,000.00 or more. Include each qualifying order once.
-- Requirement: Order by ordered_at descending, then order_id descending.
select
    o.order_id,
    o.ordered_at,
    o.customer_id,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name,
    o.status
from orders as o join customers as c on o.customer_id=c.customer_id
where exists (select 1 from order_items as oi where oi.order_id = o.order_id and oi.unit_price>=1000.00)
order by o.ordered_at DESC,o.order_id desc