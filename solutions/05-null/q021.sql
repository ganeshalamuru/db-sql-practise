-- Task (Q021): Return employee_id, first_name, last_name, and manager_id for employees who do not have a manager.
-- Requirement: Order by employee_id ascending.
SELECT employee_id, first_name, last_name, manager_id
FROM employees
WHERE manager_id IS NULL
ORDER BY employee_id;
