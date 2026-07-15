SELECT c.country_code,
       c.name AS country_name,
       w.code AS warehouse_code,
       w.name AS warehouse_name
FROM countries AS c
CROSS JOIN warehouses AS w
ORDER BY c.country_code, w.code;
