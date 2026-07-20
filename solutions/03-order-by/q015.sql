-- Task (Q015): Return employee_id, first_name, last_name, and manager_id for all employees.
-- Requirement: Order by manager_id ascending with NULL manager_id values last, then employee_id ascending.
SELECT employee_id, first_name, last_name, manager_id
FROM employees
ORDER BY manager_id ASC NULLS LAST, employee_id;
