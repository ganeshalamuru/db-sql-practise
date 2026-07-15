SELECT e.employee_id,
       e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.employee_id AS manager_id,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM employees AS e
JOIN employees AS m ON m.employee_id = e.manager_id
ORDER BY m.employee_id, e.employee_id;
