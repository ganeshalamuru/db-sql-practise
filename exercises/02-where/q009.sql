-- Task (Q009): Return payment_id, order_id, payment_method, amount, and status for completed payments made by card or wallet.
-- Requirement: Order by payment_id ascending.
select payment_id,order_id,payment_method,amount, status
from payments
where status = 'completed'
    and payment_method in ('card','wallet')
order by payment_id
