-- Task (Q152): Add a constraint named promotions_code_starts_at_unique to promotions that requires each combination of code and starts_at to be unique. Return constraint_name, constraint_type, and constraint_definition for promotions_code_starts_at_unique.
-- Requirement: No ordering is required.
ALTER TABLE promotions
ADD CONSTRAINT promotions_code_starts_at_unique
UNIQUE (code, starts_at);

SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       pg_get_constraintdef(con.oid) AS constraint_definition
FROM pg_constraint AS con
WHERE con.conrelid = 'promotions'::regclass
  AND con.conname = 'promotions_code_starts_at_unique';
