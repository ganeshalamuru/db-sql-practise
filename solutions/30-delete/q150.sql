-- Task (Q150): Delete warehouse inventory records for inactive products whose quantity_on_hand is at or above reorder_point in every warehouse where they are stocked. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each deleted inventory record.
-- Requirement: No ordering is required.
WITH inactive_replenished_products AS (
    SELECT i.product_id
    FROM inventory AS i
    JOIN products AS p ON p.product_id = i.product_id
    WHERE p.is_active = 0
    GROUP BY i.product_id
    HAVING MIN(CASE WHEN i.quantity_on_hand >= i.reorder_point THEN 1 ELSE 0 END) = 1
)
DELETE i
OUTPUT deleted.warehouse_id, deleted.product_id, deleted.quantity_on_hand, deleted.reorder_point
FROM inventory AS i
JOIN inactive_replenished_products AS irp ON irp.product_id = i.product_id;
