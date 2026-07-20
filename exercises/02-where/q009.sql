select payment_id,order_id,payment_method,amount, status
from payments
where status = 'completed'
    and payment_method in ('card','wallet')
order by payment_id