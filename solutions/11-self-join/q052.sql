-- Task (Q052): Return employee_id, employee_first_name, employee_last_name, manager_first_name, and manager_last_name for every employee, including employees who have no manager.
-- Requirement: Order by employee_id ascending.
SELECT e.employee_id,
       e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM employees AS e
LEFT JOIN employees AS m ON m.employee_id = e.manager_id
ORDER BY e.employee_id;
