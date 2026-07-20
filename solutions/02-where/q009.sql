-- Task (Q009): Return payment_id, order_id, payment_method, amount, and status for completed payments made by card or wallet.
-- Requirement: Order by payment_id ascending.
SELECT payment_id, order_id, payment_method, amount, status
FROM payments
WHERE status = 'completed'
  AND payment_method IN ('card', 'wallet')
ORDER BY payment_id;
