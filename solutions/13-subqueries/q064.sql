-- Task (Q064): Return warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory rows whose quantity_on_hand is the highest in their warehouse. Include every tied highest row.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
SELECT w.warehouse_id,
       w.code AS warehouse_code,
       i.product_id,
       p.sku,
       i.quantity_on_hand,
       i.reorder_point
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.quantity_on_hand = (
    SELECT MAX(peer.quantity_on_hand)
    FROM inventory AS peer
    WHERE peer.warehouse_id = i.warehouse_id
)
ORDER BY w.warehouse_id, i.product_id;
