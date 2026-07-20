-- Task (Q006): Return customer_id, email, first_name, and last_name for active customers.
-- Requirement: Order by customer_id ascending.
select customer_id,email,first_name,last_name from customers where status='active'
