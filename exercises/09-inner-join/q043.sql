-- Task (Q043): Return order_id, ordered_at, product_id, quantity, unit_price, and line_total for order items on paid, shipped, or delivered orders. line_total is quantity multiplied by unit_price.
-- Requirement: Order by ordered_at descending, then order_id descending, then product_id ascending.
select 
    o.order_id,
    o.ordered_at,
    product_id,
    quantity,
    unit_price,
    (quantity*unit_price) as line_total
from order_items as oi join orders as o on oi.order_id = o.order_id
where o.status IN ('paid','shipped','delivered')
order by ordered_at desc,order_id desc,product_id
