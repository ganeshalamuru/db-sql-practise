-- Task (Q153): Add a NOT VALID foreign-key constraint named orders_promotion_fk_not_valid from orders.promotion_id to promotions.promotion_id, then validate it. Return constraint_name, constraint_type, and is_validated for orders_promotion_fk_not_valid.
-- Requirement: No ordering is required.
ALTER TABLE orders
ADD CONSTRAINT orders_promotion_fk_not_valid
FOREIGN KEY (promotion_id) REFERENCES promotions (promotion_id) NOT VALID;

ALTER TABLE orders
VALIDATE CONSTRAINT orders_promotion_fk_not_valid;

SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       con.convalidated AS is_validated
FROM pg_constraint AS con
WHERE con.conrelid = 'orders'::regclass
  AND con.conname = 'orders_promotion_fk_not_valid';
