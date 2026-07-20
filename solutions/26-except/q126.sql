WITH active_product_ids AS (
    SELECT product_id
    FROM products
    WHERE is_active
), delivered_product_ids AS (
    SELECT oi.product_id
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
), never_sold_product_ids AS (
    SELECT product_id FROM active_product_ids
    EXCEPT
    SELECT product_id FROM delivered_product_ids
), warehouse_metrics AS (
    SELECT product_id,
           COUNT(warehouse_id) AS warehouse_count,
           SUM(quantity_on_hand) AS warehouse_quantity_on_hand
    FROM inventory
    GROUP BY product_id
)
SELECT p.product_id,
       p.sku,
       COALESCE(w.warehouse_count, 0) AS warehouse_count,
       COALESCE(w.warehouse_quantity_on_hand, 0) AS warehouse_quantity_on_hand
FROM never_sold_product_ids AS n
JOIN products AS p ON p.product_id = n.product_id
LEFT JOIN warehouse_metrics AS w ON w.product_id = n.product_id
ORDER BY p.product_id;
