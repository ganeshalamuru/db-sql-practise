-- Task (Q011): Return product_id, name, and unit_price for active products.
-- Requirement: Order by unit_price descending, then product_id ascending.
SELECT product_id, name, unit_price
FROM products
WHERE is_active
ORDER BY unit_price DESC, product_id;
