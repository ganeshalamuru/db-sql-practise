-- Task (Q021): Return employee_id, first_name, last_name, and manager_id for employees who do not have a manager.
-- Requirement: Order by employee_id ascending.
select employee_id,first_name,last_name,manager_id
from employees
where manager_id is NULL
order by employee_id
