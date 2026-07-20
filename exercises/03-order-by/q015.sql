-- Task (Q015): Return employee_id, first_name, last_name, and manager_id for all employees.
-- Requirement: Order by manager_id ascending with NULL manager_id values last, then employee_id ascending.
select employee_id,first_name,last_name,manager_id
from employees
order by manager_id asc NULLS LAST,employee_id
