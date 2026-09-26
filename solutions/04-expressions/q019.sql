-- Task (Q019): Return product_id, name, unit_price, and a boolean is_premium that is true when unit_price is at least 1,000.00.
-- Requirement: Order by product_id ascending.
SELECT
    product_id,
    name,
    unit_price,
    CAST(CASE WHEN unit_price >= 1000.00 THEN 1 ELSE 0 END AS BIT) AS is_premium
FROM products
ORDER BY product_id;
