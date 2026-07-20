select
    count(*) as completed_payment_count,
    sum(amount) as completed_payment_total,
    round(avg(amount),2) as average_completed_payment_amount

from payments
where status = 'completed'