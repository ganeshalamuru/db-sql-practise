WITH warehouse_countries AS (
    SELECT ci.country_id
    FROM warehouses AS w
    JOIN cities AS ci ON ci.city_id = w.city_id
), store_countries AS (
    SELECT ci.country_id
    FROM stores AS s
    JOIN cities AS ci ON ci.city_id = s.city_id
), shared_country_ids AS (
    SELECT country_id FROM warehouse_countries
    INTERSECT
    SELECT country_id FROM store_countries
), warehouse_metrics AS (
    SELECT ci.country_id,
           COUNT(w.warehouse_id) AS warehouse_count,
           SUM(w.capacity_units) AS warehouse_capacity_units
    FROM warehouses AS w
    JOIN cities AS ci ON ci.city_id = w.city_id
    GROUP BY ci.country_id
), store_metrics AS (
    SELECT ci.country_id,
           COUNT(s.store_id) AS store_count
    FROM stores AS s
    JOIN cities AS ci ON ci.city_id = s.city_id
    GROUP BY ci.country_id
)
SELECT co.country_id,
       co.country_code,
       co.name AS country_name,
       w.warehouse_count,
       s.store_count,
       w.warehouse_capacity_units
FROM shared_country_ids AS shared
JOIN countries AS co ON co.country_id = shared.country_id
JOIN warehouse_metrics AS w ON w.country_id = shared.country_id
JOIN store_metrics AS s ON s.country_id = shared.country_id
ORDER BY co.country_code;
