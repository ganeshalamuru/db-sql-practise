-- Task (Q094): Return employee_id, first_name, last_name, hierarchy_level, warehouse_code, and warehouse_name for every direct or indirect report of employee_id 1 who works in a warehouse located in India. Exclude employee_id 1.
-- Requirement: Order by hierarchy_level ascending, then employee_id ascending.
WITH RECURSIVE reports AS (
    SELECT e.employee_id, e.first_name, e.last_name, e.warehouse_id,
           0 AS hierarchy_level
    FROM employees AS e
    WHERE e.employee_id = 1

    UNION ALL

    SELECT e.employee_id, e.first_name, e.last_name, e.warehouse_id,
           r.hierarchy_level + 1
    FROM employees AS e
    JOIN reports AS r ON e.manager_id = r.employee_id
)
SELECT r.employee_id, r.first_name, r.last_name, r.hierarchy_level,
       w.code AS warehouse_code, w.name AS warehouse_name
FROM reports AS r
JOIN warehouses AS w ON w.warehouse_id = r.warehouse_id
JOIN cities AS ci ON ci.city_id = w.city_id
JOIN countries AS co ON co.country_id = ci.country_id
WHERE r.hierarchy_level > 0
  AND co.name = 'India'
ORDER BY r.hierarchy_level, r.employee_id;
