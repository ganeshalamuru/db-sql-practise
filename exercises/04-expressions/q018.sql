-- Task (Q018): Return order_id, shipping_fee, and shipping_fee plus 18 percent tax as shipping_fee_with_tax for every order.
-- Requirement: Order by order_id ascending.
select order_id,shipping_fee,(shipping_fee*118/100) as shipping_fee_with_tax
from orders
order by order_id
