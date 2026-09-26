-- Task (Q174): For each calendar month containing delivered orders, return month_start, delivered_revenue, previous_reported_month_revenue, and trailing_three_reported_month_revenue. delivered_revenue is the sum of quantity multiplied by unit_price in delivered orders. The trailing value includes the current month and the two preceding reported months.
-- Requirement: Order by month_start ascending.
WITH monthly_revenue AS (
    SELECT CAST(DATETRUNC(month, o.ordered_at) AS DATE) AS month_start,
           SUM(oi.quantity * oi.unit_price) AS delivered_revenue
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY CAST(DATETRUNC(month, o.ordered_at) AS DATE)
)
SELECT month_start,
       delivered_revenue,
       LAG(delivered_revenue) OVER (
           ORDER BY month_start
       ) AS previous_reported_month_revenue,
       SUM(delivered_revenue) OVER (
           ORDER BY month_start
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       ) AS trailing_three_reported_month_revenue
FROM monthly_revenue
ORDER BY month_start;
