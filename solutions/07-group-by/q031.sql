SELECT status, COUNT(*) AS order_count, SUM(shipping_fee) AS total_shipping_fee
FROM orders
GROUP BY status
ORDER BY total_shipping_fee DESC, status;
