SELECT COUNT(*) AS completed_payment_count
FROM payments
WHERE status = 'completed';
