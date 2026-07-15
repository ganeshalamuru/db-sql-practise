SELECT sh.shipment_id,
       sh.status AS shipment_status,
       w.code AS warehouse_code,
       w.name AS warehouse_name,
       ci.name AS city_name,
       co.name AS country_name
FROM shipments AS sh
JOIN warehouses AS w ON w.warehouse_id = sh.warehouse_id
JOIN cities AS ci ON ci.city_id = w.city_id
JOIN countries AS co ON co.country_id = ci.country_id
WHERE sh.status = 'delivered'
ORDER BY country_name, city_name, warehouse_code, sh.shipment_id;
