-- Task (Q026): Return active_customer_count, suspended_customer_count, and closed_customer_count: the number of customers in each respective status.
-- Requirement: The result has one row; no ordering is needed.
select 
    count(case when status='active' then 1 end) as active_customer_count,
    count(case when status='suspended' then 1 end) as suspended_customer_count,
    count(case when status='closed' then 1 end) as closed_customer_count
from customers
