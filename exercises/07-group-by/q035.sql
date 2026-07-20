-- Task (Q035): For active products only, return supplier_id, active_product_count, and average_active_product_price. Round average_active_product_price to two decimal places.
-- Requirement: Order by average_active_product_price descending, then active_product_count descending, then supplier_id ascending.
select 
    supplier_id,
    count(*) as active_product_count,
    round(avg(unit_price),2) as average_active_product_price
from products
where is_active=true
group by supplier_id
order by average_active_product_price desc,active_product_count desc,supplier_id
