-- Task (Q054): Return employee_id, first_name, last_name, and direct_report_count for every employee, including employees with no direct reports.
-- Requirement: Order by direct_report_count descending, then employee_id ascending.
select
    m.employee_id,
    m.first_name,
    m.last_name,
    count(e.employee_id) as direct_report_count
from employees as m left join employees as e on m.employee_id=e.manager_id
group by m.employee_id
order by direct_report_count desc,employee_id
