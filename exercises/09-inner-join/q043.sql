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