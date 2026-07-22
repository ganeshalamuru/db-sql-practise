-- Task (Q150): Delete warehouse inventory records for inactive products whose quantity_on_hand is at or above reorder_point in every warehouse where they are stocked. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each deleted inventory record.
-- Requirement: No ordering is required.
WITH inactive_replenished_products AS (
    SELECT i.product_id
    FROM inventory AS i
    JOIN products AS p ON p.product_id = i.product_id
    WHERE NOT p.is_active
    GROUP BY i.product_id
    HAVING BOOL_AND(i.quantity_on_hand >= i.reorder_point)
)
DELETE FROM inventory AS i
USING inactive_replenished_products AS irp
WHERE i.product_id = irp.product_id
RETURNING i.warehouse_id, i.product_id, i.quantity_on_hand, i.reorder_point;
