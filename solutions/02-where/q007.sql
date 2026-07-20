-- Task (Q007): Return product_id, sku, name, and unit_price for active products priced above 1,000.00.
-- Requirement: Order by unit_price ascending, then product_id ascending.
SELECT product_id, sku, name, unit_price
FROM products
WHERE is_active
  AND unit_price > 1000.00
ORDER BY unit_price, product_id;
