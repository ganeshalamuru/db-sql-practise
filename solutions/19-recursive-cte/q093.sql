-- Task (Q093): Return employee_id, first_name, last_name, manager_id, hierarchy_level, and reporting_path for every employee. reporting_path contains employee IDs from the hierarchy root to the employee, separated by ' > '.
-- Requirement: Order by reporting_path ascending, then employee_id ascending.
WITH RECURSIVE employee_hierarchy AS (
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id,
           0 AS hierarchy_level, e.employee_id::TEXT AS reporting_path
    FROM employees AS e
    WHERE e.manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id,
           parent.hierarchy_level + 1,
           parent.reporting_path || ' > ' || e.employee_id::TEXT
    FROM employees AS e
    JOIN employee_hierarchy AS parent ON e.manager_id = parent.employee_id
)
SELECT employee_id, first_name, last_name, manager_id, hierarchy_level, reporting_path
FROM employee_hierarchy
ORDER BY reporting_path, employee_id;
