-- Task (Q087): Return order_id, ordered_at, status, and item_total for orders with an item_total of at least 1,000.00. item_total is the sum of quantity multiplied by unit_price across each order's line items.
-- Requirement: Order by item_total descending, then order_id ascending.
WITH order_item_totals AS (
    SELECT oi.order_id, SUM(oi.quantity * oi.unit_price) AS item_total
    FROM order_items AS oi
    GROUP BY oi.order_id
)
SELECT o.order_id, o.ordered_at, o.status, t.item_total
FROM orders AS o
JOIN order_item_totals AS t ON t.order_id = o.order_id
WHERE t.item_total >= 1000.00
ORDER BY t.item_total DESC, o.order_id;
