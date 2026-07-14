SELECT product_id, name, unit_price
FROM products
WHERE is_active
ORDER BY unit_price DESC, product_id;
