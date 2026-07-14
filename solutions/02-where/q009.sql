SELECT payment_id, order_id, payment_method, amount, status
FROM payments
WHERE status = 'completed'
  AND payment_method IN ('card', 'wallet')
ORDER BY payment_id;
