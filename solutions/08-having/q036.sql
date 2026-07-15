SELECT payment_method, COUNT(*) AS completed_payment_count
FROM payments
WHERE status = 'completed'
GROUP BY payment_method
HAVING COUNT(*) >= 100
ORDER BY completed_payment_count DESC, payment_method;
