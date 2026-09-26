-- Task (Q134): Create or replace a view named vw_low_stock_inventory that returns warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory records whose quantity_on_hand is at or below reorder_point. Then return every row from vw_low_stock_inventory.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
CREATE OR ALTER VIEW vw_customer_order_history AS
SELECT c.customer_id,
       c.email,
       COUNT(o.order_id) AS order_count,
       SUM(o.shipping_fee) AS total_shipping_fees
FROM customers AS c
JOIN orders AS o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.email;

SELECT customer_id,
       email,
       order_count,
       total_shipping_fees
FROM vw_customer_order_history
ORDER BY customer_id;
