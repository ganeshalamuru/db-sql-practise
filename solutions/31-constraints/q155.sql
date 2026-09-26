-- Task (Q155): Add a constraint named promotions_discount_window_limit to promotions that requires a promotion to last no more than 730 days. Return constraint_name, constraint_type, and constraint_definition for promotions_discount_window_limit.
-- Requirement: No ordering is required.
ALTER TABLE promotions
ADD CONSTRAINT promotions_discount_window_limit
CHECK (DATEDIFF(day, starts_at, ends_at) <= 730);

SELECT name AS constraint_name,
       type_desc AS constraint_type,
       definition AS constraint_definition
FROM sys.check_constraints
WHERE name = 'promotions_discount_window_limit';
