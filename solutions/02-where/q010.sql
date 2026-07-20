-- Task (Q010): Return warehouse_id, product_id, quantity_on_hand, and reorder_point for inventory rows at or below their reorder point.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
SELECT warehouse_id, product_id, quantity_on_hand, reorder_point
FROM inventory
WHERE quantity_on_hand <= reorder_point
ORDER BY warehouse_id, product_id;
