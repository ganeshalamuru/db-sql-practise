SELECT s.store_id,
       s.code AS store_code,
       w.warehouse_id,
       w.code AS warehouse_code
FROM stores AS s
CROSS JOIN warehouses AS w
WHERE s.city_id <> w.city_id
ORDER BY s.store_id, w.warehouse_id;
