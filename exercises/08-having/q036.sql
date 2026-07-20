-- Task (Q036): Return payment_method and completed_payment_count for payment methods with at least 100 completed payments.
-- Requirement: Order by completed_payment_count descending, then payment_method ascending.
select 
    payment_method,
    count(*) as completed_payment_count
from payments
where status='completed'
group by payment_method
having count(*)>=100
order by completed_payment_count desc,payment_method
