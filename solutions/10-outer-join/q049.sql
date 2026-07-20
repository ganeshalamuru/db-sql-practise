-- Task (Q049): Return warehouse_id, warehouse_code, and total_units_on_hand for every warehouse, including warehouses with no inventory rows. Show 0 rather than NULL for total_units_on_hand.
-- Requirement: Order by total_units_on_hand descending, then warehouse_id ascending.
SELECT w.warehouse_id,
       w.code AS warehouse_code,
       COALESCE(SUM(i.quantity_on_hand), 0) AS total_units_on_hand
FROM warehouses AS w
LEFT JOIN inventory AS i ON i.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_id, w.code
ORDER BY total_units_on_hand DESC, w.warehouse_id;
