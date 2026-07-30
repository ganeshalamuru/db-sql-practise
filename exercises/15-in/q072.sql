-- Task (Q072): Return customer_id, email, first_name, and last_name for customers who have not placed an order with status paid, shipped, or delivered.
-- Requirement: Order by customer_id ascending.
select 
    c.customer_id,
    c.email,
    c.first_name,
    c.last_name
from customers as c
where not exists (select 1 from orders as o where o.customer_id=c.customer_id and o.status in ('paid','shipped','delivered'))
order by c.customer_id