-- Task (Q114): Return delivery_month, delivered_item_total, previous_month_delivered_item_total, and month_over_month_change for every calendar month from the earliest to the latest delivered order, including months with no delivered orders. delivery_month is the first calendar date of each month. delivered_item_total is 0 for a month with no delivered orders. previous_month_delivered_item_total is NULL for the first returned month, and month_over_month_change is delivered_item_total minus the previous month's total.
-- Requirement: Order by delivery_month ascending.
WITH monthly_delivered_sales AS (
    SELECT DATE_TRUNC('month', o.ordered_at)::DATE AS delivery_month,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.ordered_at)::DATE
), date_bounds AS (
    SELECT MIN(delivery_month) AS first_month,
           MAX(delivery_month) AS last_month
    FROM monthly_delivered_sales
), calendar_months AS (
    SELECT series.generated_month::DATE AS delivery_month
    FROM date_bounds
    CROSS JOIN LATERAL GENERATE_SERIES(
        first_month,
        last_month,
        INTERVAL '1 month'
    ) AS series(generated_month)
), monthly_totals AS (
    SELECT c.delivery_month,
           COALESCE(s.delivered_item_total, 0) AS delivered_item_total
    FROM calendar_months AS c
    LEFT JOIN monthly_delivered_sales AS s ON s.delivery_month = c.delivery_month
), monthly_comparison AS (
    SELECT delivery_month,
           delivered_item_total,
           LAG(delivered_item_total) OVER (
               ORDER BY delivery_month
           ) AS previous_month_delivered_item_total
    FROM monthly_totals
)
SELECT delivery_month,
       delivered_item_total,
       previous_month_delivered_item_total,
       delivered_item_total - previous_month_delivered_item_total
           AS month_over_month_change
FROM monthly_comparison
ORDER BY delivery_month;
