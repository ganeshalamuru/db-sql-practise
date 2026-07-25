-- Task (Q151): Add a constraint named products_unit_price_ceiling to products that requires unit_price to be at most 1000000. Return constraint_name, constraint_type, and constraint_definition for products_unit_price_ceiling.
-- Requirement: No ordering is required.
ALTER TABLE products
ADD CONSTRAINT products_unit_price_ceiling
CHECK (unit_price <= 1000000);

SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       pg_get_constraintdef(con.oid) AS constraint_definition
FROM pg_constraint AS con
WHERE con.conrelid = 'products'::regclass
  AND con.conname = 'products_unit_price_ceiling';
