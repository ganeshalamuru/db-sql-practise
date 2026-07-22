-- Task (Q143): For inventory records of inactive products, set reorder_point to quantity_on_hand plus 10. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each updated inventory record.
-- Requirement: No ordering is required.
UPDATE inventory AS i
SET reorder_point = i.quantity_on_hand + 10
FROM products AS p
WHERE p.product_id = i.product_id
  AND NOT p.is_active
RETURNING i.warehouse_id, i.product_id, i.quantity_on_hand, i.reorder_point;
