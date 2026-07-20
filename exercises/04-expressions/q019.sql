-- Task (Q019): Return product_id, name, unit_price, and a boolean is_premium that is true when unit_price is at least 1,000.00.
-- Requirement: Order by product_id ascending.
select product_id,name,unit_price,(unit_price>=1000) as is_premium
from products
order by product_id
