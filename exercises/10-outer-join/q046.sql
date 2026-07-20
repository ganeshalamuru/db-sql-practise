-- Task (Q046): Return customer_id, email, first_name, and last_name for customers who have never placed an order.
-- Requirement: Order by customer_id ascending.
select 
    c.customer_id as customer_id,
    c.email as email,
    c.first_name as first_name,
    c.last_name as last_name
from customers as c left join orders as o on c.customer_id = o.customer_id
where o.order_id is NULL
order by customer_id
