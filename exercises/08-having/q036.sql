select 
    payment_method,
    count(*) as completed_payment_count
from payments
where status='completed'
group by payment_method
having count(*)>=100
order by completed_payment_count desc,payment_method