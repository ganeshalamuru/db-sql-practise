-- Task (Q027): For completed payments only, return completed_payment_count, completed_payment_total, and average_completed_payment_amount. Round the average amount to two decimal places.
-- Requirement: The result has one row; no ordering is needed.
SELECT COUNT(*) AS completed_payment_count,
       SUM(amount) AS completed_payment_total,
       ROUND(AVG(amount), 2) AS average_completed_payment_amount
FROM payments
WHERE status = 'completed';
