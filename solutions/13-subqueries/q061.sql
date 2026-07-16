SELECT product_id,
       sku,
       name,
       unit_price
FROM products
WHERE is_active
  AND unit_price > (
      SELECT AVG(unit_price)
      FROM products
      WHERE is_active
  )
ORDER BY unit_price DESC, product_id;
