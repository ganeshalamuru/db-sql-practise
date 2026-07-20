-- Task (Q030): For orders placed during 2024, return first_ordered_at, last_ordered_at, order_count, and average_shipping_fee. Round the average shipping fee to two decimal places.
-- Requirement: The result has one row; no ordering is needed.
SELECT
    MIN(ordered_at) AS first_ordered_at,
    MAX(ordered_at) AS last_ordered_at,
    COUNT(*) AS order_count,
    ROUND(AVG(shipping_fee), 2) AS average_shipping_fee
FROM orders
WHERE ordered_at >= TIMESTAMPTZ '2024-01-01 00:00:00+00'
  AND ordered_at < TIMESTAMPTZ '2025-01-01 00:00:00+00';
