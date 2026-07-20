-- Task (Q024): Return order_id, customer_id, ordered_at, and status for cancelled orders that have no promotion applied.
-- Requirement: Order by order_id ascending.
select order_id,customer_id,ordered_at,status
from orders
where status = 'cancelled' and promotion_id is null
