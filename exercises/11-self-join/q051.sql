-- Task (Q051): Return employee_id, employee_first_name, employee_last_name, manager_id, manager_first_name, and manager_last_name for employees who have a manager.
-- Requirement: Order by manager_id ascending, then employee_id ascending.
select
    e.employee_id,
    e.first_name as employee_first_name,
    e.last_name as employee_last_name,
    e.manager_id,
    m.first_name as manager_first_name,
    m.last_name as manager_last_name
from employees as e join employees as m on e.manager_id=m.employee_id
order by manager_id,employee_id
