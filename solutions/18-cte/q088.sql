-- Task (Q088): Return warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory rows at or below their reorder point, but only for active products.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
WITH low_stock AS (
    SELECT i.warehouse_id, i.product_id, i.quantity_on_hand, i.reorder_point
    FROM inventory AS i
    WHERE i.quantity_on_hand <= i.reorder_point
)
SELECT w.warehouse_id, w.code AS warehouse_code, l.product_id, p.sku,
       l.quantity_on_hand, l.reorder_point
FROM low_stock AS l
JOIN warehouses AS w ON w.warehouse_id = l.warehouse_id
JOIN products AS p ON p.product_id = l.product_id
WHERE p.is_active
ORDER BY w.warehouse_id, l.product_id;
