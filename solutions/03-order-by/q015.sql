-- Task (Q015): Return employee_id, first_name, last_name, and manager_id for all employees.
-- Requirement: Order by manager_id ascending with NULL manager_id values last, then employee_id ascending.
SELECT employee_id, first_name, last_name, manager_id
FROM employees
ORDER BY CASE WHEN manager_id IS NULL THEN 1 ELSE 0 END, manager_id ASC, employee_id;
