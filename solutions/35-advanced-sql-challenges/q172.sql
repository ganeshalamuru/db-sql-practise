-- Task (Q172): For every customer who has placed at least one order, return customer_id, streak_start_date, streak_end_date, and consecutive_order_days for that customer's longest streak of consecutive calendar days with at least one order. If a customer has equally long streaks, return the earliest one.
-- Requirement: Order by customer_id ascending.
WITH daily_orders AS (
    SELECT DISTINCT customer_id,
           CAST(ordered_at AS DATE) AS order_date
    FROM orders
), streak_groups AS (
    SELECT customer_id,
           order_date,
           DATEADD(day, -CAST(ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY order_date
           ) AS INT), order_date) AS streak_group
    FROM daily_orders
), streaks AS (
    SELECT customer_id,
           MIN(order_date) AS streak_start_date,
           MAX(order_date) AS streak_end_date,
           COUNT(*) AS consecutive_order_days
    FROM streak_groups
    GROUP BY customer_id, streak_group
), ranked_streaks AS (
    SELECT customer_id,
           streak_start_date,
           streak_end_date,
           consecutive_order_days,
           ROW_NUMBER() OVER (
               PARTITION BY customer_id
               ORDER BY consecutive_order_days DESC, streak_start_date
           ) AS streak_position
    FROM streaks
)
SELECT customer_id,
       streak_start_date,
       streak_end_date,
       consecutive_order_days
FROM ranked_streaks
WHERE streak_position = 1
ORDER BY customer_id;
