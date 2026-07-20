-- Task (Q020): Return product_id, sku, unit_price, and price_in_cents, where price_in_cents is unit_price multiplied by 100.
-- Requirement: Order by product_id ascending.
select product_id,sku,unit_price,(unit_price*100) as price_in_cents
from products
order by product_id
