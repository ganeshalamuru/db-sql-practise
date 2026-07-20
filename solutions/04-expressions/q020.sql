-- Task (Q020): Return product_id, sku, unit_price, and price_in_cents, where price_in_cents is unit_price multiplied by 100.
-- Requirement: Order by product_id ascending.
SELECT
    product_id,
    sku,
    unit_price,
    unit_price * 100 AS price_in_cents
FROM products
ORDER BY product_id;
