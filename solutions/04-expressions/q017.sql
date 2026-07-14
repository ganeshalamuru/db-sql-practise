SELECT
    warehouse_id,
    product_id,
    quantity_on_hand,
    reorder_point,
    quantity_on_hand - reorder_point AS units_above_reorder
FROM inventory
ORDER BY warehouse_id, product_id;
