-- Task (Q141): Update customer_id 1 so its status is 'suspended'. Return customer_id, email, and status for the updated customer.
-- Requirement: No ordering is required.
UPDATE customers
SET status = 'suspended'
WHERE customer_id = 1
RETURNING customer_id, email, status;
