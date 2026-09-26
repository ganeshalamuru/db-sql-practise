-- Task (Q158): Start a transaction and create a savepoint named product_price_before_change. Increase product_id 1's unit_price by 10, then roll back to the savepoint. Return product_id, sku, and unit_price for product_id 1 before rolling back the transaction.
-- Requirement: No ordering is required.
BEGIN TRANSACTION;

SAVE TRANSACTION product_price_before_change;

UPDATE products
SET unit_price = unit_price + 10
WHERE product_id = 1;

ROLLBACK TRANSACTION product_price_before_change;

SELECT product_id, sku, unit_price
FROM products
WHERE product_id = 1;

ROLLBACK TRANSACTION;
