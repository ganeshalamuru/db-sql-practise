select employee_id,first_name,last_name,manager_id
from employees
order by manager_id asc NULLS LAST,employee_id