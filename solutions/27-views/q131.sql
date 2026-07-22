-- Task (Q131): Create or replace a view named vw_active_products that returns product_id, sku, name, and unit_price for active products. Then return every row from vw_active_products.
-- Requirement: Order by product_id ascending.
CREATE OR REPLACE VIEW vw_active_products AS
SELECT product_id,
       sku,
       name,
       unit_price
FROM products
WHERE is_active;

SELECT product_id,
       sku,
       name,
       unit_price
FROM vw_active_products
ORDER BY product_id;
