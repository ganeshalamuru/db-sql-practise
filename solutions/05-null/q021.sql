SELECT employee_id, first_name, last_name, manager_id
FROM employees
WHERE manager_id IS NULL
ORDER BY employee_id;
