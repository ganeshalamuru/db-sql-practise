-- Task (Q056): Return country_code, country_name, warehouse_code, and warehouse_name for every possible country-and-warehouse combination.
-- Requirement: Order by country_code ascending, then warehouse_code ascending.
SELECT c.country_code,
       c.name AS country_name,
       w.code AS warehouse_code,
       w.name AS warehouse_name
FROM countries AS c
CROSS JOIN warehouses AS w
ORDER BY c.country_code, w.code;
