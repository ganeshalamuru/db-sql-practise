-- Task (Q027): For completed payments only, return completed_payment_count, completed_payment_total, and average_completed_payment_amount. Round the average amount to two decimal places.
-- Requirement: The result has one row; no ordering is needed.
select
    count(*) as completed_payment_count,
    sum(amount) as completed_payment_total,
    round(avg(amount),2) as average_completed_payment_amount

from payments
where status = 'completed'
