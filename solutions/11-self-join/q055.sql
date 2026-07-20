-- Task (Q055): Return employee_id, employee_first_name, employee_last_name, manager_first_name, manager_last_name, grandmanager_first_name, and grandmanager_last_name for employees whose manager also has a manager.
-- Requirement: Order by employee_id ascending.
SELECT e.employee_id,
       e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name,
       gm.first_name AS grandmanager_first_name,
       gm.last_name AS grandmanager_last_name
FROM employees AS e
JOIN employees AS m ON m.employee_id = e.manager_id
JOIN employees AS gm ON gm.employee_id = m.manager_id
ORDER BY e.employee_id;
