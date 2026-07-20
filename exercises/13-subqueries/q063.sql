-- Task (Q063): Return customer_id, email, first_name, and last_name for customers who have placed more orders than the average number of orders per customer. Treat the average as the total number of orders divided by the number of distinct customers who placed an order.
-- Requirement: Order by customer_id ascending.
select
    o.customer_id,
    c.email,
    c.first_name,
    c.last_name
from orders as o join customers as c on o.customer_id = c.customer_id
group by o.customer_id,c.email,c.first_name,c.last_name
having count(c.customer_id) > (select count(oo.order_id)/count(distinct oo.customer_id) from orders as oo)
order by o.customer_id
