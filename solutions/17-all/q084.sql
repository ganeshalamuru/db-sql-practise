-- Task (Q084): Return warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory rows whose quantity_on_hand is at least as high as every inventory quantity for the same product in other warehouses. Include ties.
-- Requirement: Order by product_id ascending, then warehouse_id ascending.
SELECT w.warehouse_id, w.code AS warehouse_code, i.product_id, p.sku,
       i.quantity_on_hand, i.reorder_point
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.quantity_on_hand >= ALL (
    SELECT peer.quantity_on_hand FROM inventory AS peer
    WHERE peer.product_id = i.product_id AND peer.warehouse_id <> i.warehouse_id
)
ORDER BY i.product_id, w.warehouse_id;
