-- Task (Q002): Return the distinct payment methods that have been used by completed payments.
-- Requirement: Order alphabetically by payment_method.
SELECT DISTINCT payment_method
FROM payments
WHERE status = 'completed'
ORDER BY payment_method;
