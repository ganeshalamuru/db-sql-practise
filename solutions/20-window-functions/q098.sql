WITH ordered_orders AS (
    SELECT o.customer_id,
           o.order_id,
           o.ordered_at,
           LAG(o.order_id) OVER (
               PARTITION BY o.customer_id
               ORDER BY o.ordered_at, o.order_id
           ) AS previous_order_id,
           LAG(o.ordered_at) OVER (
               PARTITION BY o.customer_id
               ORDER BY o.ordered_at, o.order_id
           ) AS previous_ordered_at
    FROM orders AS o
)
SELECT customer_id,
       order_id,
       ordered_at,
       previous_order_id,
       previous_ordered_at,
       ordered_at - previous_ordered_at AS time_since_previous_order
FROM ordered_orders
WHERE previous_order_id IS NOT NULL
ORDER BY customer_id, ordered_at, order_id;
