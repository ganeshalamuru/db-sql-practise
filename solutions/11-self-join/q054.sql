-- Task (Q054): Return employee_id, first_name, last_name, and direct_report_count for every employee, including employees with no direct reports.
-- Requirement: Order by direct_report_count descending, then employee_id ascending.
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       COUNT(r.employee_id) AS direct_report_count
FROM employees AS e
LEFT JOIN employees AS r ON r.manager_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY direct_report_count DESC, e.employee_id;
