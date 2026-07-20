select
    o.customer_id,
    c.email,
    c.first_name,
    c.last_name
from orders as o join customers as c on o.customer_id = c.customer_id
group by o.customer_id,c.email,c.first_name,c.last_name
having count(c.customer_id) > (select count(oo.order_id)/count(distinct oo.customer_id) from orders as oo)
order by o.customer_id