-- Task (Q153): Add a NOT VALID foreign-key constraint named orders_promotion_fk_not_valid from orders.promotion_id to promotions.promotion_id, then validate it. Return constraint_name, constraint_type, and is_validated for orders_promotion_fk_not_valid.
-- Requirement: No ordering is required.
ALTER TABLE orders
WITH NOCHECK ADD CONSTRAINT orders_promotion_fk_not_valid
FOREIGN KEY (promotion_id) REFERENCES promotions (promotion_id);

ALTER TABLE orders
WITH CHECK CHECK CONSTRAINT orders_promotion_fk_not_valid;

SELECT name AS constraint_name,
       type_desc AS constraint_type,
       CASE WHEN is_not_trusted = 0 THEN 1 ELSE 0 END AS is_validated
FROM sys.foreign_keys
WHERE name = 'orders_promotion_fk_not_valid';
