-- Task (Q017): Return warehouse_id, product_id, quantity_on_hand, reorder_point, and units_above_reorder (quantity_on_hand minus reorder_point) for all inventory rows.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
SELECT
    warehouse_id,
    product_id,
    quantity_on_hand,
    reorder_point,
    quantity_on_hand - reorder_point AS units_above_reorder
FROM inventory
ORDER BY warehouse_id, product_id;
