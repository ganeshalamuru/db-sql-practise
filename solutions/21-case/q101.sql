WITH delivered_customer_totals AS (
    SELECT o.customer_id,
           COUNT(DISTINCT o.order_id) AS delivered_order_count,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
)
SELECT c.customer_id,
       c.email,
       COALESCE(d.delivered_order_count, 0) AS delivered_order_count,
       COALESCE(d.delivered_item_total, 0) AS delivered_item_total,
       CASE
           WHEN COALESCE(d.delivered_order_count, 0) = 0 THEN 'no_delivered_orders'
           WHEN d.delivered_item_total >= 50000.00 THEN 'high_value'
           ELSE 'standard_value'
       END AS customer_value_tier
FROM customers AS c
LEFT JOIN delivered_customer_totals AS d ON d.customer_id = c.customer_id
ORDER BY delivered_item_total DESC, c.customer_id;
