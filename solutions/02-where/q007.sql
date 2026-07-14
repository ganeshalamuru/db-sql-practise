SELECT product_id, sku, name, unit_price
FROM products
WHERE is_active
  AND unit_price > 1000.00
ORDER BY unit_price, product_id;
