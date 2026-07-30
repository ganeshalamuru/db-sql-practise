-- Task (Q165): For every delivered order, return order_id, customer_id, and items, where items is a JSONB array ordered by product_id. Each array element must be a JSONB object with keys product_id, sku, quantity, and unit_price for one order item.
-- Requirement: Order by order_id ascending.
SELECT o.order_id,
       o.customer_id,
       jsonb_agg(
           jsonb_build_object(
               'product_id', oi.product_id,
               'sku', p.sku,
               'quantity', oi.quantity,
               'unit_price', oi.unit_price
           )
           ORDER BY oi.product_id
       ) AS items
FROM orders AS o
JOIN order_items AS oi ON oi.order_id = o.order_id
JOIN products AS p ON p.product_id = oi.product_id
WHERE o.status = 'delivered'
GROUP BY o.order_id, o.customer_id
ORDER BY o.order_id;
