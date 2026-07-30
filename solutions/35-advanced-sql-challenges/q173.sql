-- Task (Q173): Return category_id, product_id, sku, stocked_warehouse_count, and total_quantity_on_hand for every active product stocked in at least one warehouse that is at or below its reorder_point in every warehouse where it is stocked.
-- Requirement: Order by category_id ascending, then product_id ascending.
SELECT p.category_id,
       p.product_id,
       p.sku,
       COUNT(i.warehouse_id) AS stocked_warehouse_count,
       SUM(i.quantity_on_hand) AS total_quantity_on_hand
FROM products AS p
JOIN inventory AS i ON i.product_id = p.product_id
WHERE p.is_active
GROUP BY p.category_id, p.product_id, p.sku
HAVING BOOL_AND(i.quantity_on_hand <= i.reorder_point)
ORDER BY p.category_id, p.product_id;
