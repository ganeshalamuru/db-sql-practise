-- Task (Q151): Add a constraint named products_unit_price_ceiling to products that requires unit_price to be at most 1000000. Return constraint_name, constraint_type, and constraint_definition for products_unit_price_ceiling.
-- Requirement: No ordering is required.
ALTER TABLE products
ADD CONSTRAINT products_unit_price_ceiling
CHECK (unit_price <= 1000000);

SELECT name AS constraint_name,
       type_desc AS constraint_type,
       definition AS constraint_definition
FROM sys.check_constraints
WHERE name = 'products_unit_price_ceiling';
