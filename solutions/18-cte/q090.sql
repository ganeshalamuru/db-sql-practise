WITH delivered_customer_totals AS (
    SELECT o.customer_id,
           COUNT(DISTINCT o.order_id) AS delivered_order_count,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
), average_delivered_total AS (
    SELECT AVG(delivered_item_total) AS delivered_item_total_average
    FROM delivered_customer_totals
)
SELECT c.customer_id, c.email, c.first_name, c.last_name,
       d.delivered_order_count, d.delivered_item_total
FROM delivered_customer_totals AS d
JOIN customers AS c ON c.customer_id = d.customer_id
CROSS JOIN average_delivered_total AS a
WHERE d.delivered_item_total > a.delivered_item_total_average
ORDER BY d.delivered_item_total DESC, c.customer_id;
