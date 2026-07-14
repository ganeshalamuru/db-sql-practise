SELECT
    product_id,
    name,
    unit_price,
    unit_price >= 1000.00 AS is_premium
FROM products
ORDER BY product_id;
