WITH ordered_customer_orders AS (
    SELECT o.customer_id,
           o.order_id,
           o.ordered_at::DATE AS ordered_date,
           LAG(o.order_id) OVER (
               PARTITION BY o.customer_id
               ORDER BY o.ordered_at, o.order_id
           ) AS previous_order_id,
           LAG(o.ordered_at::DATE) OVER (
               PARTITION BY o.customer_id
               ORDER BY o.ordered_at, o.order_id
           ) AS previous_ordered_date
    FROM orders AS o
)
SELECT customer_id,
       order_id,
       ordered_date,
       previous_order_id,
       previous_ordered_date,
       ordered_date - previous_ordered_date AS days_since_previous_order
FROM ordered_customer_orders
WHERE previous_order_id IS NOT NULL
  AND ordered_date - previous_ordered_date <= 120
ORDER BY customer_id, ordered_date, order_id;
