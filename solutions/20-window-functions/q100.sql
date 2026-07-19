WITH customer_delivered_totals AS (
    SELECT co.country_id,
           co.country_code,
           co.name AS country_name,
           c.customer_id,
           c.email,
           COUNT(DISTINCT o.order_id) AS delivered_order_count,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM customers AS c
    JOIN cities AS ci ON ci.city_id = c.city_id
    JOIN countries AS co ON co.country_id = ci.country_id
    JOIN orders AS o ON o.customer_id = c.customer_id
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY co.country_id, co.country_code, co.name, c.customer_id, c.email
), ranked_customers AS (
    SELECT country_code,
           country_name,
           customer_id,
           email,
           delivered_order_count,
           delivered_item_total,
           DENSE_RANK() OVER (
               PARTITION BY country_id
               ORDER BY delivered_item_total DESC
           ) AS country_spend_rank
    FROM customer_delivered_totals
)
SELECT country_code,
       country_name,
       customer_id,
       email,
       delivered_order_count,
       delivered_item_total,
       country_spend_rank
FROM ranked_customers
WHERE country_spend_rank <= 2
ORDER BY country_code, country_spend_rank, customer_id;
