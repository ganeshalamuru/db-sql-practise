-- Task (Q031): Return status, order_count, and total_shipping_fee: the number of orders and the sum of shipping_fee for each order status.
-- Requirement: Order by total_shipping_fee descending, then status ascending.
SELECT status, COUNT(*) AS order_count, SUM(shipping_fee) AS total_shipping_fee
FROM orders
GROUP BY status
ORDER BY total_shipping_fee DESC, status;
