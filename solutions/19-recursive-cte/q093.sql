-- Task (Q093): Return employee_id, first_name, last_name, manager_id, hierarchy_level, and reporting_path for every employee. reporting_path contains employee IDs from the hierarchy root to the employee, separated by ' > '.
-- Requirement: Order by reporting_path ascending, then employee_id ascending.
WITH employee_hierarchy AS (
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id,
           0 AS hierarchy_level, CAST(e.employee_id AS VARCHAR(1000)) AS reporting_path
    FROM employees AS e
    WHERE e.manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id,
           parent.hierarchy_level + 1,
           CAST(parent.reporting_path + ' > ' + CAST(e.employee_id AS VARCHAR(10)) AS VARCHAR(1000))
    FROM employees AS e
    JOIN employee_hierarchy AS parent ON e.manager_id = parent.employee_id
)
SELECT employee_id, first_name, last_name, manager_id, hierarchy_level, reporting_path
FROM employee_hierarchy
ORDER BY reporting_path, employee_id;
