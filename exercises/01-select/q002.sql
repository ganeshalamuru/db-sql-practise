-- Task (Q002): Return the distinct payment methods that have been used by completed payments.
-- Requirement: Order alphabetically by payment_method.
select distinct(payment_method) from payments where status = 'completed' order by payment_method
