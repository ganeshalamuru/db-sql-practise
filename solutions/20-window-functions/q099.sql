WITH product_delivered_revenue AS (
    SELECT oi.product_id,
           SUM(oi.quantity * oi.unit_price) AS delivered_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY oi.product_id
), active_product_revenue AS (
    SELECT p.category_id,
           p.product_id,
           p.sku,
           COALESCE(r.delivered_revenue, 0) AS delivered_revenue
    FROM products AS p
    LEFT JOIN product_delivered_revenue AS r ON r.product_id = p.product_id
    WHERE p.is_active
), ranked_product_revenue AS (
    SELECT category_id,
           product_id,
           sku,
           delivered_revenue,
           SUM(delivered_revenue) OVER (
               PARTITION BY category_id
           ) AS category_delivered_revenue,
           DENSE_RANK() OVER (
               PARTITION BY category_id
               ORDER BY delivered_revenue DESC
           ) AS revenue_rank
    FROM active_product_revenue
)
SELECT c.category_id,
       c.name AS category_name,
       p.product_id,
       p.sku,
       p.delivered_revenue,
       p.category_delivered_revenue,
       100 * p.delivered_revenue / NULLIF(p.category_delivered_revenue, 0)
           AS revenue_share_percent,
       p.revenue_rank
FROM ranked_product_revenue AS p
JOIN categories AS c ON c.category_id = p.category_id
ORDER BY c.category_id, p.revenue_rank, p.product_id;
