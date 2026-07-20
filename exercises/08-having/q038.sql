select 
    product_id,
    sum(unit_price*quantity) as total_sales_value
from order_items
group by product_id
having sum(unit_price*quantity)>25000
order by total_sales_value desc,product_id