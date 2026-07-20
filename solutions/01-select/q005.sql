-- Task (Q005): Return all columns for countries in the reference data.
-- Requirement: Order by country_code ascending.
SELECT country_id, country_code, name
FROM countries
ORDER BY country_code;
