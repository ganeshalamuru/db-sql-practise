-- Task (Q102): Return product_id, sku, warehouse_count, low_stock_warehouse_count, and inventory_health for every active product. warehouse_count is the number of warehouses that stock the product. low_stock_warehouse_count is the number of those rows where quantity_on_hand is at or below reorder_point. inventory_health is not_stocked when warehouse_count is 0, reorder_needed when low_stock_warehouse_count is positive, and adequately_stocked otherwise.
-- Requirement: Order by inventory_health ascending, then product_id ascending.
WITH product_stock AS (
    SELECT p.product_id,
           p.sku,
           COUNT(i.warehouse_id) AS warehouse_count,
           COUNT(*) FILTER (
               WHERE i.quantity_on_hand <= i.reorder_point
           ) AS low_stock_warehouse_count
    FROM products AS p
    LEFT JOIN inventory AS i ON i.product_id = p.product_id
    WHERE p.is_active
    GROUP BY p.product_id, p.sku
)
SELECT product_id,
       sku,
       warehouse_count,
       low_stock_warehouse_count,
       CASE
           WHEN warehouse_count = 0 THEN 'not_stocked'
           WHEN low_stock_warehouse_count > 0 THEN 'reorder_needed'
           ELSE 'adequately_stocked'
       END AS inventory_health
FROM product_stock
ORDER BY inventory_health, product_id;
