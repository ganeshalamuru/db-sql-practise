-- Task (Q028): Return total_units_on_hand, total_reorder_point, and units_above_reorder across all inventory rows. units_above_reorder is the sum of quantity_on_hand minus reorder_point only for rows where quantity_on_hand is greater than reorder_point; do not let below-reorder rows reduce this value.
-- Requirement: The result has one row; no ordering is needed.
SELECT SUM(quantity_on_hand) AS total_units_on_hand,
       SUM(reorder_point) AS total_reorder_point,
       SUM(quantity_on_hand - reorder_point)
           FILTER (WHERE quantity_on_hand > reorder_point) AS units_above_reorder
FROM inventory;
