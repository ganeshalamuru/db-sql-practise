-- Task (Q016): Return order_id, product_id, quantity, unit_price, and line_total (quantity multiplied by unit_price) for every order item.
-- Requirement: Order by order_id ascending, then product_id ascending.
select order_id,product_id,quantity,unit_price,(quantity*unit_price) as line_total
from order_items
order by order_id,product_id
