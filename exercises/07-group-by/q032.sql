-- Task (Q032): Return customer_id, order_count, first_ordered_at, and last_ordered_at for each customer who has placed at least one order.
-- Requirement: Order by order_count descending, then customer_id ascending.
select
    customer_id,
    count(*) as order_count,
    min(ordered_at) as first_ordered_at,
    max(ordered_at) as last_ordered_at
from orders
group by customer_id
order by order_count desc,customer_id
