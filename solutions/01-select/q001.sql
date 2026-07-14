SELECT product_id, sku, name, unit_price
FROM products
WHERE is_active
ORDER BY product_id;
