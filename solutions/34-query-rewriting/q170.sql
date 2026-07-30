-- Task (Q170): For each customer with at least one delivered order, calculate lifetime_delivered_spend as the sum of quantity multiplied by unit_price in delivered orders. Return customer_id, city_id, lifetime_delivered_spend, and city_average_delivered_spend for customers whose lifetime_delivered_spend is greater than the average among qualifying customers in the same city. Exclude customers with no city.
-- Requirement: Order by city_id ascending, then lifetime_delivered_spend descending, then customer_id ascending.
WITH customer_spend AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS lifetime_delivered_spend
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
), city_benchmarks AS (
    SELECT c.customer_id,
           c.city_id,
           cs.lifetime_delivered_spend,
           AVG(cs.lifetime_delivered_spend) OVER (
               PARTITION BY c.city_id
           ) AS city_average_delivered_spend
    FROM customer_spend AS cs
    JOIN customers AS c ON c.customer_id = cs.customer_id
    WHERE c.city_id IS NOT NULL
)
SELECT customer_id,
       city_id,
       lifetime_delivered_spend,
       city_average_delivered_spend
FROM city_benchmarks
WHERE lifetime_delivered_spend > city_average_delivered_spend
ORDER BY city_id, lifetime_delivered_spend DESC, customer_id;
