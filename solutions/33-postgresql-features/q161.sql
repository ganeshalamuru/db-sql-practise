-- Task (Q161): Return product_id, sku, and name for every product whose name contains 'wireless', regardless of letter case.
-- Requirement: Order by product_id ascending.
SELECT product_id,
       sku,
       name
FROM products
WHERE name ILIKE '%wireless%'
ORDER BY product_id;
