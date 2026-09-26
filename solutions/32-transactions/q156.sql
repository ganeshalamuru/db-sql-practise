-- Task (Q156): Start a transaction, set customer_id 1 to status 'suspended', and return customer_id, email, and status for that customer before rolling back the transaction.
-- Requirement: No ordering is required.
BEGIN TRANSACTION;

UPDATE customers
SET status = 'suspended'
WHERE customer_id = 1;

SELECT customer_id, email, status
FROM customers
WHERE customer_id = 1;

ROLLBACK TRANSACTION;
