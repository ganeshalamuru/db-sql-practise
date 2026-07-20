-- Task (Q128): Return product_id, sku, warehouse_count, and warehouse_quantity_on_hand for active products with positive quantity_on_hand in at least one warehouse and no positive quantity_on_hand in any store. warehouse_count and warehouse_quantity_on_hand consider only warehouse rows with positive quantity.
-- Requirement: Order by product_id ascending.
WITH warehouse_stock AS (
    SELECT product_id,
           COUNT(warehouse_id) AS warehouse_count,
           SUM(quantity_on_hand) AS warehouse_quantity_on_hand
    FROM inventory
    WHERE quantity_on_hand > 0
    GROUP BY product_id
), store_stock_product_ids AS (
    SELECT product_id
    FROM store_inventory
    WHERE quantity_on_hand > 0
), warehouse_only_product_ids AS (
    SELECT product_id FROM warehouse_stock
    EXCEPT
    SELECT product_id FROM store_stock_product_ids
)
SELECT p.product_id,
       p.sku,
       w.warehouse_count,
       w.warehouse_quantity_on_hand
FROM warehouse_only_product_ids AS warehouse_only
JOIN products AS p ON p.product_id = warehouse_only.product_id
JOIN warehouse_stock AS w ON w.product_id = warehouse_only.product_id
WHERE p.is_active
ORDER BY p.product_id;
