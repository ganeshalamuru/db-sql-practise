-- Task (Q099): Return category_id, category_name, product_id, sku, delivered_revenue, category_delivered_revenue, revenue_share_percent, and revenue_rank for every active product. delivered_revenue is the sum of quantity multiplied by unit_price for delivered orders, including 0 for products with no delivered sales. category_delivered_revenue is the delivered_revenue total for the product's category. revenue_share_percent is 100 multiplied by delivered_revenue divided by category_delivered_revenue, or NULL when the category total is 0. revenue_rank is the dense rank within the category by delivered_revenue descending, with ties sharing a rank.
-- Requirement: Order by category_id ascending, revenue_rank ascending, then product_id ascending.
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
