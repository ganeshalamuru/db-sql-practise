select
    e.employee_id,
    e.first_name as employee_first_name,
    e.last_name as employee_last_name,
    m.first_name as manager_first_name,
    m.last_name as manager_last_name,
    gm.first_name as grandmanager_first_name,
    gm.last_name as grandmanager_last_name
from employees as e join employees as m on e.manager_id=m.employee_id
join employees as gm on m.manager_id=gm.employee_id
order by employee_id
