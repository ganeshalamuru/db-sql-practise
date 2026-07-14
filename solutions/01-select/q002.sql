SELECT DISTINCT payment_method
FROM payments
WHERE status = 'completed'
ORDER BY payment_method;
