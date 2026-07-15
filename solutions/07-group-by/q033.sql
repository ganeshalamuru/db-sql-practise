SELECT warehouse_id,
       SUM(quantity_on_hand) AS total_units_on_hand,
       SUM(reorder_point) AS total_reorder_point,
       SUM(quantity_on_hand - reorder_point)
           FILTER (WHERE quantity_on_hand > reorder_point) AS units_above_reorder
FROM inventory
GROUP BY warehouse_id
ORDER BY units_above_reorder, warehouse_id;
