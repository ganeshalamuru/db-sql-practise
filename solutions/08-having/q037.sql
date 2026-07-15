SELECT warehouse_id, SUM(quantity_on_hand) AS total_units_on_hand
FROM inventory
GROUP BY warehouse_id
HAVING SUM(quantity_on_hand) > 50000
ORDER BY total_units_on_hand DESC, warehouse_id;
