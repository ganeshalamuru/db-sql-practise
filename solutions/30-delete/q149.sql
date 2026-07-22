-- Task (Q149): Delete returns whose order has a payment with status failed. Return return_id, order_id, product_id, and status for each deleted return.
-- Requirement: No ordering is required.
DELETE FROM returns AS r
WHERE EXISTS (
    SELECT 1
    FROM payments AS p
    WHERE p.order_id = r.order_id
      AND p.status = 'failed'
)
RETURNING r.return_id, r.order_id, r.product_id, r.status;
