-- Task (Q098): Return customer_id, order_id, ordered_at, previous_order_id, previous_ordered_at, and time_since_previous_order for every order except each customer's first order. previous_order_id and previous_ordered_at identify the immediately preceding order for the same customer, ordered by ordered_at and then order_id. time_since_previous_order is ordered_at minus previous_ordered_at.
-- Requirement: Order by customer_id ascending, ordered_at ascending, then order_id ascending.
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
