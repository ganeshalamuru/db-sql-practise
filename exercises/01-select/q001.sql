-- Task (Q001): Return each active product's product_id, sku, name, and unit_price.
-- Requirement: Order by product_id ascending.
select product_id, sku, name, unit_price from products where is_active=true
