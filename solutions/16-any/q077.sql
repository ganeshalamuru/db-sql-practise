SELECT p.payment_id, p.order_id, p.payment_method, p.amount, p.status
FROM payments AS p
WHERE p.payment_method = ANY (
    SELECT failed.payment_method FROM payments AS failed WHERE failed.status = 'failed'
)
ORDER BY p.payment_id;
