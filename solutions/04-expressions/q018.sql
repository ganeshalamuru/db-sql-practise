-- Task (Q018): Return order_id, shipping_fee, and shipping_fee plus 18 percent tax as shipping_fee_with_tax for every order.
-- Requirement: Order by order_id ascending.
SELECT
    order_id,
    shipping_fee,
    shipping_fee * 1.18 AS shipping_fee_with_tax
FROM orders
ORDER BY order_id;
