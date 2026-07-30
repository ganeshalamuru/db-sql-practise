  -- Task (Q075): Return order_id, ordered_at, customer_id, customer_first_name, customer_last_name, and order_item_count for orders placed by customers who have also submitted at least one review with a rating of 5. Include only orders containing at least two line items.
-- Requirement: Order by ordered_at descending, then order_id descending.

select
    oo.order_id,
    ords.ordered_at,
    ords.customer_id,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name,
    oo.order_item_count

from (select o.order_id,count(oi.product_id) as order_item_count 
    from orders as o 
    join order_items as oi on o.order_id = oi.order_id
    group by o.order_id 
    having count(oi.product_id)>=2) as oo 
    join orders as ords on oo.order_id=ords.order_id 
    join customers as c on ords.customer_id = c.customer_id
where ords.customer_id in (select r.customer_id 
                            from reviews as r 
                            where r.rating=5)
order by ords.ordered_at desc, oo.order_id desc