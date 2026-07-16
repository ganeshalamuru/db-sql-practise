SELECT w.warehouse_id, w.code AS warehouse_code, i.product_id, p.sku, i.quantity_on_hand
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.quantity_on_hand > ANY (
    SELECT peer.reorder_point FROM inventory AS peer
    WHERE peer.warehouse_id = i.warehouse_id AND peer.product_id <> i.product_id
)
ORDER BY w.warehouse_id, i.product_id;
