-- Task (Q143): For inventory records of inactive products, set reorder_point to quantity_on_hand plus 10. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each updated inventory record.
-- Requirement: No ordering is required.
UPDATE i
SET reorder_point = i.quantity_on_hand + 10
OUTPUT inserted.warehouse_id, inserted.product_id, inserted.quantity_on_hand, inserted.reorder_point
FROM inventory AS i
JOIN products AS p ON p.product_id = i.product_id
WHERE p.is_active = 0;
