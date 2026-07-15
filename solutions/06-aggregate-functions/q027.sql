SELECT COUNT(*) AS completed_payment_count,
       SUM(amount) AS completed_payment_total,
       ROUND(AVG(amount), 2) AS average_completed_payment_amount
FROM payments
WHERE status = 'completed';
