select order_id,shipping_fee,(shipping_fee*118/100) as shipping_fee_with_tax
from orders
order by order_id