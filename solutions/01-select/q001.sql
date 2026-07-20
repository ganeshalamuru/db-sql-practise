-- Task (Q001): Return each active product's product_id, sku, name, and unit_price.
-- Requirement: Order by product_id ascending.
SELECT product_id, sku, name, unit_price
FROM products
WHERE is_active
ORDER BY product_id;
