-- Task (Q086): Return product_id, sku, name, and unit_price for active products priced above the average unit_price of all active products.
-- Requirement: Order by unit_price descending, then product_id ascending.
WITH active_price_average AS (
    SELECT AVG(unit_price) AS unit_price_average
    FROM products
    WHERE is_active
)
SELECT p.product_id, p.sku, p.name, p.unit_price
FROM products AS p
CROSS JOIN active_price_average AS a
WHERE p.is_active AND p.unit_price > a.unit_price_average
ORDER BY p.unit_price DESC, p.product_id;
