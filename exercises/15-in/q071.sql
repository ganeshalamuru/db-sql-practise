-- Task (Q071): Return product_id, sku, name, and unit_price for products supplied by suppliers located in the same country as the customer whose email is 'customer1@example.test'.
-- Requirement: Order by product_id ascending.
select 
    product_id,
    sku,
    name,
    unit_price
from products
where supplier_id in (select s.supplier_id from suppliers as s where s.country_id = (select c.country_id from cities as c where c.city_id = (select cus.city_id from customers as cus where cus.email = 'customer1@example.test') ))
order by product_id