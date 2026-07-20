-- Task (Q029): For active products only, return active_product_count, lowest_active_product_price, highest_active_product_price, and average_active_product_price. Round the average price to two decimal places.
-- Requirement: The result has one row; no ordering is needed.
select 
    count(*) as active_product_count,
    min(unit_price) as lowest_active_product_price,
    max(unit_price) as highest_active_product_price,
    round(avg(unit_price),2) as average_active_product_price
from products
where is_active=true
