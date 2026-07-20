-- Task (Q052): Return employee_id, employee_first_name, employee_last_name, manager_first_name, and manager_last_name for every employee, including employees who have no manager.
-- Requirement: Order by employee_id ascending.
select 
    e.employee_id,
    e.first_name as employee_first_name,
    e.last_name as employee_last_name,
    m.first_name as manager_first_name,
    m.last_name as manager_last_name
from employees as e left join employees as m on e.manager_id=m.employee_id
order by employee_id
