WITH RECURSIVE reports AS (
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id, 0 AS hierarchy_level
    FROM employees AS e
    WHERE e.employee_id = 1

    UNION ALL

    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id,
           r.hierarchy_level + 1
    FROM employees AS e
    JOIN reports AS r ON e.manager_id = r.employee_id
)
SELECT employee_id, first_name, last_name, manager_id, hierarchy_level
FROM reports
ORDER BY hierarchy_level, employee_id;
