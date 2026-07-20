-- Task (Q111): Return delivery_month, delivered_order_count, delivered_item_total, and average_monthly_delivered_item_total for every month containing delivered orders. delivery_month is the first calendar date of the month. delivered_item_total is the sum of quantity multiplied by unit_price across delivered orders in that month. average_monthly_delivered_item_total is the average delivered_item_total across the returned months.
-- Requirement: Order by delivery_month ascending.
WITH monthly_delivered_sales AS (
    SELECT DATE_TRUNC('month', o.ordered_at)::DATE AS delivery_month,
           COUNT(DISTINCT o.order_id) AS delivered_order_count,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.ordered_at)::DATE
)
SELECT delivery_month,
       delivered_order_count,
       delivered_item_total,
       AVG(delivered_item_total) OVER () AS average_monthly_delivered_item_total
FROM monthly_delivered_sales
ORDER BY delivery_month;
