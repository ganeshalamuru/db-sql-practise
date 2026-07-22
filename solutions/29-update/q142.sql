-- Task (Q142): Reduce unit_price by 10 percent for products supplied by supplier_id 40. Return product_id, sku, and unit_price for each updated product.
-- Requirement: No ordering is required.
UPDATE products
SET unit_price = unit_price * 0.90
WHERE supplier_id = 40
RETURNING product_id, sku, unit_price;
