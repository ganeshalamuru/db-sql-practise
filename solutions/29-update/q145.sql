-- Task (Q145): For every inventory record belonging to a product that has at least one warehouse where quantity_on_hand is at or below reorder_point, increase reorder_point by 5. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each updated inventory record.
-- Requirement: No ordering is required.
WITH at_or_below_reorder_products AS (
    SELECT product_id
    FROM inventory
    GROUP BY product_id
    HAVING MAX(CASE WHEN quantity_on_hand <= reorder_point THEN 1 ELSE 0 END) = 1
)
UPDATE i
SET reorder_point = i.reorder_point + 5
OUTPUT inserted.warehouse_id, inserted.product_id, inserted.quantity_on_hand, inserted.reorder_point
FROM inventory AS i
JOIN at_or_below_reorder_products AS abrp ON abrp.product_id = i.product_id;
