-- Task (Q015): Return employee_id, first_name, last_name, and manager_id for all employees.
-- Requirement: Order by manager_id ascending with NULL manager_id values last, then employee_id ascending.
select employee_id,first_name,last_name,manager_id
from employees
order by case when manager_id is null then 1 else 0 end, manager_id asc, employee_id
