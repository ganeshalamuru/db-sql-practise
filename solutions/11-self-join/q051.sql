-- Task (Q051): Return employee_id, employee_first_name, employee_last_name, manager_id, manager_first_name, and manager_last_name for employees who have a manager.
-- Requirement: Order by manager_id ascending, then employee_id ascending.
SELECT e.employee_id,
       e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.employee_id AS manager_id,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM employees AS e
JOIN employees AS m ON m.employee_id = e.manager_id
ORDER BY m.employee_id, e.employee_id;
