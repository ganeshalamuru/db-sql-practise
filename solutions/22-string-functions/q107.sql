-- Task (Q107): Return customer_id, customer_name, email_username, email_domain, and delivered_item_total for customers whose delivered_item_total is above the average among customers with at least one delivered order. customer_name joins the first and last name with one space and uses title case. email_username and email_domain are the portions of email before and after '@'. delivered_item_total is the sum of quantity multiplied by unit_price across delivered orders.
-- Requirement: Order by delivered_item_total descending, then customer_id ascending.
WITH delivered_customer_totals AS (
    SELECT o.customer_id,
           SUM(oi.quantity * oi.unit_price) AS delivered_item_total
    FROM orders AS o
    JOIN order_items AS oi ON oi.order_id = o.order_id
    WHERE o.status = 'delivered'
    GROUP BY o.customer_id
), average_delivered_total AS (
    SELECT AVG(delivered_item_total) AS delivered_item_total_average
    FROM delivered_customer_totals
)
SELECT c.customer_id,
       INITCAP(CONCAT_WS(' ', c.first_name, c.last_name)) AS customer_name,
       SPLIT_PART(c.email, '@', 1) AS email_username,
       SPLIT_PART(c.email, '@', 2) AS email_domain,
       d.delivered_item_total
FROM delivered_customer_totals AS d
JOIN customers AS c ON c.customer_id = d.customer_id
CROSS JOIN average_delivered_total AS a
WHERE d.delivered_item_total > a.delivered_item_total_average
ORDER BY d.delivered_item_total DESC, c.customer_id;
