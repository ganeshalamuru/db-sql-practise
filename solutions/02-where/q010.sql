SELECT warehouse_id, product_id, quantity_on_hand, reorder_point
FROM inventory
WHERE quantity_on_hand <= reorder_point
ORDER BY warehouse_id, product_id;
