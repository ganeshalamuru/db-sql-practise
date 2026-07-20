-- Task (Q057): Return store_id, store_code, warehouse_id, and warehouse_code for every store-and-warehouse pair located in different cities.
-- Requirement: Order by store_id ascending, then warehouse_id ascending.
SELECT s.store_id,
       s.code AS store_code,
       w.warehouse_id,
       w.code AS warehouse_code
FROM stores AS s
CROSS JOIN warehouses AS w
WHERE s.city_id <> w.city_id
ORDER BY s.store_id, w.warehouse_id;
