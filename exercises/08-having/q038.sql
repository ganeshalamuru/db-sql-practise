-- Task (Q038): Return product_id and total_sales_value for products whose total value across all order items exceeds 25,000.00. Compute each line's value as quantity multiplied by unit_price.
-- Requirement: Order by total_sales_value descending, then product_id ascending.
select 
    product_id,
    sum(unit_price*quantity) as total_sales_value
from order_items
group by product_id
having sum(unit_price*quantity)>25000
order by total_sales_value desc,product_id
