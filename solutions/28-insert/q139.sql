-- Task (Q139): Insert inventory records for warehouse_id 10 and product IDs 1 through 5. Each inserted row must have quantity_on_hand 0 and reorder_point 25. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each inserted inventory record.
-- Requirement: No ordering is required.
INSERT INTO inventory (warehouse_id, product_id, quantity_on_hand, reorder_point)
SELECT 10,
       product_id,
       0,
       25
FROM products
WHERE product_id BETWEEN 1 AND 5
RETURNING warehouse_id, product_id, quantity_on_hand, reorder_point;
