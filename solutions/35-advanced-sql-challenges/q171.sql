-- Task (Q171): For every active product that appears in a delivered order, return category_id, product_id, sku, delivered_revenue, and revenue_rank. delivered_revenue is the sum of quantity multiplied by unit_price from delivered orders. Rank products within each category by delivered_revenue descending, retaining ties with RANK.
-- Requirement: Order by category_id ascending, then revenue_rank ascending, then product_id ascending.
WITH product_revenue AS (
    SELECT p.category_id,
           p.product_id,
           p.sku,
           SUM(oi.quantity * oi.unit_price) AS delivered_revenue
    FROM products AS p
    JOIN order_items AS oi ON oi.product_id = p.product_id
    JOIN orders AS o ON o.order_id = oi.order_id
    WHERE p.is_active = 1
      AND o.status = 'delivered'
    GROUP BY p.category_id, p.product_id, p.sku
)
SELECT category_id,
       product_id,
       sku,
       delivered_revenue,
       RANK() OVER (
           PARTITION BY category_id
           ORDER BY delivered_revenue DESC
       ) AS revenue_rank
FROM product_revenue
ORDER BY category_id, revenue_rank, product_id;
