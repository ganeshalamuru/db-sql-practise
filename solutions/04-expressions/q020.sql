SELECT
    product_id,
    sku,
    unit_price,
    unit_price * 100 AS price_in_cents
FROM products
ORDER BY product_id;
