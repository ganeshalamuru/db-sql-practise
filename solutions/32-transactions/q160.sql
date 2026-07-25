-- Task (Q160): Start a transaction and use a CTE that locks the product_id 1 inventory rows for warehouse_id 1 and warehouse_id 2. Transfer 5 units from warehouse_id 1 to warehouse_id 2, then return warehouse_id, product_id, quantity_on_hand, and reorder_point for those two rows before rolling back the transaction.
-- Requirement: Order by warehouse_id ascending.
BEGIN;

WITH locked_inventory AS (
    SELECT warehouse_id, product_id
    FROM inventory
    WHERE product_id = 1
      AND warehouse_id IN (1, 2)
    FOR UPDATE
)
UPDATE inventory AS i
SET quantity_on_hand = i.quantity_on_hand
    + CASE WHEN i.warehouse_id = 1 THEN -5 ELSE 5 END
FROM locked_inventory AS li
WHERE i.warehouse_id = li.warehouse_id
  AND i.product_id = li.product_id;

SELECT warehouse_id, product_id, quantity_on_hand, reorder_point
FROM inventory
WHERE product_id = 1
  AND warehouse_id IN (1, 2)
ORDER BY warehouse_id;

ROLLBACK;
