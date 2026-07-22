-- Task (Q145): For every inventory record belonging to a product that has at least one warehouse where quantity_on_hand is at or below reorder_point, increase reorder_point by 5. Return warehouse_id, product_id, quantity_on_hand, and reorder_point for each updated inventory record.
-- Requirement: No ordering is required.
WITH at_or_below_reorder_products AS (
    SELECT product_id
    FROM inventory
    GROUP BY product_id
    HAVING BOOL_OR(quantity_on_hand <= reorder_point)
)
UPDATE inventory AS i
SET reorder_point = i.reorder_point + 5
FROM at_or_below_reorder_products AS abrp
WHERE abrp.product_id = i.product_id
RETURNING i.warehouse_id, i.product_id, i.quantity_on_hand, i.reorder_point;
