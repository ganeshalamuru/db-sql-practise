-- Task (Q105): Return category_id, category_name, product_id, sku, delivered_revenue, category_average_delivered_revenue, and revenue_performance for every active product. delivered_revenue is the sum of quantity multiplied by unit_price in delivered orders, including 0 for products with no delivered sales. category_average_delivered_revenue is the average delivered_revenue among active products in that category. revenue_performance is no_delivered_revenue when delivered_revenue is 0, above_category_average when it is above the category average, and at_or_below_category_average otherwise.
-- Requirement: Order by category_id ascending, delivered_revenue descending, then product_id ascending.
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
), benchmarked_product_revenue AS (
    SELECT category_id,
           product_id,
           sku,
           delivered_revenue,
           AVG(delivered_revenue) OVER (
               PARTITION BY category_id
           ) AS category_average_delivered_revenue
    FROM active_product_revenue
)
SELECT c.category_id,
       c.name AS category_name,
       p.product_id,
       p.sku,
       p.delivered_revenue,
       p.category_average_delivered_revenue,
       CASE
           WHEN p.delivered_revenue = 0 THEN 'no_delivered_revenue'
           WHEN p.delivered_revenue > p.category_average_delivered_revenue
               THEN 'above_category_average'
           ELSE 'at_or_below_category_average'
       END AS revenue_performance
FROM benchmarked_product_revenue AS p
JOIN categories AS c ON c.category_id = p.category_id
ORDER BY c.category_id, p.delivered_revenue DESC, p.product_id;
