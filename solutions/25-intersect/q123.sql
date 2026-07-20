WITH warehouse_stock AS (
    SELECT product_id,
           COUNT(warehouse_id) AS warehouse_count
    FROM inventory
    WHERE quantity_on_hand > 0
    GROUP BY product_id
), store_stock AS (
    SELECT product_id,
           COUNT(store_id) AS store_count
    FROM store_inventory
    WHERE quantity_on_hand > 0
    GROUP BY product_id
), stocked_in_both_product_ids AS (
    SELECT product_id FROM warehouse_stock
    INTERSECT
    SELECT product_id FROM store_stock
)
SELECT p.product_id,
       p.sku,
       w.warehouse_count,
       s.store_count
FROM stocked_in_both_product_ids AS b
JOIN products AS p ON p.product_id = b.product_id
JOIN warehouse_stock AS w ON w.product_id = b.product_id
JOIN store_stock AS s ON s.product_id = b.product_id
WHERE p.is_active
ORDER BY p.product_id;
