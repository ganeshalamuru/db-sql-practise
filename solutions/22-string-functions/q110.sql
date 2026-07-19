WITH product_delivered_revenue AS (
    SELECT oi.product_id,
           SUM(oi.quantity * oi.unit_price) AS delivered_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY oi.product_id
), ranked_active_products AS (
    SELECT p.category_id,
           p.product_id,
           p.sku,
           COALESCE(r.delivered_revenue, 0) AS delivered_revenue,
           DENSE_RANK() OVER (
               PARTITION BY p.category_id
               ORDER BY COALESCE(r.delivered_revenue, 0) DESC
           ) AS revenue_rank
    FROM products AS p
    LEFT JOIN product_delivered_revenue AS r ON r.product_id = p.product_id
    WHERE p.is_active
)
SELECT c.category_id,
       c.name AS category_name,
       UPPER(LEFT(c.name, 3)) || '-' || LPAD(c.category_id::TEXT, 2, '0')
           AS category_code,
       MAX(p.delivered_revenue) AS top_delivered_revenue,
       STRING_AGG(p.sku, ' | ' ORDER BY p.sku) AS top_sku_list
FROM categories AS c
JOIN ranked_active_products AS p ON p.category_id = c.category_id
WHERE p.revenue_rank = 1
GROUP BY c.category_id, c.name
ORDER BY c.category_id;
