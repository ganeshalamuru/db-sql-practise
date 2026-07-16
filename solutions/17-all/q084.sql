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
