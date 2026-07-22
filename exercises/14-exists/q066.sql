-- Task (Q066): Return customer_id, email, first_name, and last_name for customers who have placed at least one order.
-- Requirement: Order by customer_id ascending.
select 
    customer_id,
    email,
    first_name,
    last_name
from customers as c
where exists (select * from orders as o where o.customer_id = c.customer_id)
order by customer_id