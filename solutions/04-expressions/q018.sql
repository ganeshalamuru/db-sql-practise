SELECT
    order_id,
    shipping_fee,
    shipping_fee * 1.18 AS shipping_fee_with_tax
FROM orders
ORDER BY order_id;
