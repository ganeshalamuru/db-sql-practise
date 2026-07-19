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
