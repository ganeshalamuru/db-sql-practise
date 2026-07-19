WITH product_delivered_quantities AS (
    SELECT oi.product_id,
           SUM(oi.quantity) AS delivered_quantity
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY oi.product_id
), active_product_quantities AS (
    SELECT p.category_id,
           p.product_id,
           p.sku,
           COALESCE(q.delivered_quantity, 0) AS delivered_quantity
    FROM products AS p
    LEFT JOIN product_delivered_quantities AS q ON q.product_id = p.product_id
    WHERE p.is_active
)
SELECT c.category_id,
       c.name AS category_name,
       p.product_id,
       p.sku,
       p.delivered_quantity,
       DENSE_RANK() OVER (
           PARTITION BY p.category_id
           ORDER BY p.delivered_quantity DESC
       ) AS delivered_quantity_rank
FROM active_product_quantities AS p
JOIN categories AS c ON c.category_id = p.category_id
ORDER BY c.category_id, delivered_quantity_rank, p.product_id;
