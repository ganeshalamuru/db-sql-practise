-- Task (Q045): Return shipment_id, shipment_status, warehouse_code, warehouse_name, city_name, and country_name for delivered shipments.
-- Requirement: Order by country_name ascending, city_name ascending, warehouse_code ascending, then shipment_id ascending.
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
