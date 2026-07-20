select 
    count(*) FILTER(where status='active') as active_customer_count,
    count(*) FILTER(where status='suspended') as suspended_customer_count,
    count(*) FILTER(where status='closed') as closed_customer_count
from customers