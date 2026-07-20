-- Task (Q036): Return payment_method and completed_payment_count for payment methods with at least 100 completed payments.
-- Requirement: Order by completed_payment_count descending, then payment_method ascending.
SELECT payment_method, COUNT(*) AS completed_payment_count
FROM payments
WHERE status = 'completed'
GROUP BY payment_method
HAVING COUNT(*) >= 100
ORDER BY completed_payment_count DESC, payment_method;
