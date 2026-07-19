SELECT c.customer_id,
       c.email,
       MIN(o.ordered_at)::DATE AS first_delivered_date,
       MAX(o.ordered_at)::DATE AS last_delivered_date,
       MAX(o.ordered_at)::DATE - MIN(o.ordered_at)::DATE
           AS days_between_first_and_last_delivery,
       COUNT(DISTINCT o.order_id) AS delivered_order_count
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
WHERE o.status = 'delivered'
GROUP BY c.customer_id, c.email
HAVING COUNT(DISTINCT o.order_id) >= 2
ORDER BY days_between_first_and_last_delivery DESC, c.customer_id;
