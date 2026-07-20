select
    e.employee_id,
    e.first_name as employee_first_name,
    e.last_name as employee_last_name,
    e.manager_id,
    m.first_name as manager_first_name,
    m.last_name as manager_last_name
from employees as e join employees as m on e.manager_id=m.employee_id
order by manager_id,employee_id