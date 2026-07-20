-- Task (Q014): Return order_id, product_id, quantity, unit_price, and line_total (quantity multiplied by unit_price) for all order items.
-- Requirement: Order by line_total descending, then order_id ascending, then product_id ascending.
select order_id,product_id,quantity,unit_price,(quantity*unit_price) as line_total
from order_items
order by line_total desc,order_id asc
