-- Task (Q073): Return warehouse_id, warehouse_code, product_id, sku, and quantity_on_hand for inventory rows whose product_id appears in at least one return with status requested or approved.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
SELECT w.warehouse_id, w.code AS warehouse_code, i.product_id, p.sku, i.quantity_on_hand
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.product_id IN (
    SELECT r.product_id FROM returns AS r
    WHERE r.status IN ('requested', 'approved')
)
ORDER BY w.warehouse_id, i.product_id;
