-- Task (Q117): Return country_code, city_name, location_type, location_code, location_name, capacity_units, and employee_count for every warehouse and store. For warehouses, include capacity_units and the number of employees assigned to the warehouse. For stores, capacity_units and employee_count must be NULL. location_type is warehouse or store.
-- Requirement: Order by country_code ascending, location_type ascending, then location_code ascending.
WITH warehouse_employee_counts AS (
    SELECT w.warehouse_id,
           COUNT(e.employee_id) AS employee_count
    FROM warehouses AS w
    LEFT JOIN employees AS e ON e.warehouse_id = w.warehouse_id
    GROUP BY w.warehouse_id
)
SELECT co.country_code,
       ci.name AS city_name,
       'warehouse'::TEXT AS location_type,
       w.code AS location_code,
       w.name AS location_name,
       w.capacity_units,
       e.employee_count
FROM warehouses AS w
JOIN cities AS ci ON ci.city_id = w.city_id
JOIN countries AS co ON co.country_id = ci.country_id
JOIN warehouse_employee_counts AS e ON e.warehouse_id = w.warehouse_id

UNION ALL

SELECT co.country_code,
       ci.name AS city_name,
       'store'::TEXT AS location_type,
       s.code AS location_code,
       s.name AS location_name,
       NULL::INTEGER AS capacity_units,
       NULL::BIGINT AS employee_count
FROM stores AS s
JOIN cities AS ci ON ci.city_id = s.city_id
JOIN countries AS co ON co.country_id = ci.country_id

ORDER BY country_code, location_type, location_code;
