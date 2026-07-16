SELECT w.warehouse_id, w.code AS warehouse_code, i.product_id, p.sku, i.quantity_on_hand
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.product_id IN (
    SELECT r.product_id FROM returns AS r
    WHERE r.status IN ('requested', 'approved')
)
ORDER BY w.warehouse_id, i.product_id;
