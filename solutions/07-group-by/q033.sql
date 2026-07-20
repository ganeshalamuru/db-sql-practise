-- Task (Q033): Return warehouse_id, total_units_on_hand, total_reorder_point, and units_above_reorder. For each warehouse, units_above_reorder is the sum of quantity_on_hand minus reorder_point only for rows where quantity_on_hand is greater than reorder_point; below-reorder rows must not reduce this value.
-- Requirement: Order by units_above_reorder ascending, then warehouse_id ascending.
SELECT warehouse_id,
       SUM(quantity_on_hand) AS total_units_on_hand,
       SUM(reorder_point) AS total_reorder_point,
       SUM(quantity_on_hand - reorder_point)
           FILTER (WHERE quantity_on_hand > reorder_point) AS units_above_reorder
FROM inventory
GROUP BY warehouse_id
ORDER BY units_above_reorder, warehouse_id;
