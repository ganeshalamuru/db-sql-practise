-- Task (Q037): Return warehouse_id and total_units_on_hand for warehouses whose total quantity_on_hand is greater than 50,000.
-- Requirement: Order by total_units_on_hand descending, then warehouse_id ascending.
SELECT warehouse_id, SUM(quantity_on_hand) AS total_units_on_hand
FROM inventory
GROUP BY warehouse_id
HAVING SUM(quantity_on_hand) > 50000
ORDER BY total_units_on_hand DESC, warehouse_id;
