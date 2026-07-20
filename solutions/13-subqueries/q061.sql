-- Task (Q061): Return product_id, sku, name, and unit_price for active products priced above the average unit_price of all active products.
-- Requirement: Order by unit_price descending, then product_id ascending.
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
