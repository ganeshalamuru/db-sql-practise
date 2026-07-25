-- Task (Q155): Add a constraint named promotions_discount_window_limit to promotions that requires a promotion to last no more than 730 days. Return constraint_name, constraint_type, and constraint_definition for promotions_discount_window_limit.
-- Requirement: No ordering is required.
ALTER TABLE promotions
ADD CONSTRAINT promotions_discount_window_limit
CHECK (ends_at <= starts_at + INTERVAL '730 days');

SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       pg_get_constraintdef(con.oid) AS constraint_definition
FROM pg_constraint AS con
WHERE con.conrelid = 'promotions'::regclass
  AND con.conname = 'promotions_discount_window_limit';
