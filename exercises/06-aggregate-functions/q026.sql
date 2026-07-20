-- Task (Q026): Return active_customer_count, suspended_customer_count, and closed_customer_count: the number of customers in each respective status.
-- Requirement: The result has one row; no ordering is needed.
select 
    count(*) FILTER(where status='active') as active_customer_count,
    count(*) FILTER(where status='suspended') as suspended_customer_count,
    count(*) FILTER(where status='closed') as closed_customer_count
from customers
