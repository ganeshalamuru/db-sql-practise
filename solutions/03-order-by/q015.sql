SELECT employee_id, first_name, last_name, manager_id
FROM employees
ORDER BY manager_id ASC NULLS LAST, employee_id;
