-- Task (Q077): Return payment_id, order_id, payment_method, amount, and status for payments whose payment_method is used by at least one failed payment.
-- Requirement: Order by payment_id ascending.
SELECT p.payment_id, p.order_id, p.payment_method, p.amount, p.status
FROM payments AS p
WHERE p.payment_method = ANY (
    SELECT failed.payment_method FROM payments AS failed WHERE failed.status = 'failed'
)
ORDER BY p.payment_id;
