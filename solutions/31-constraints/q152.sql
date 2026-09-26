-- Task (Q152): Add a constraint named promotions_code_starts_at_unique to promotions that requires each combination of code and starts_at to be unique. Return constraint_name, constraint_type, and constraint_definition for promotions_code_starts_at_unique.
-- Requirement: No ordering is required.
ALTER TABLE promotions
ADD CONSTRAINT promotions_code_starts_at_unique
UNIQUE (code, starts_at);

SELECT name AS constraint_name,
       type_desc AS constraint_type,
       'UNIQUE (code, starts_at)' AS constraint_definition
FROM sys.key_constraints
WHERE name = 'promotions_code_starts_at_unique';
