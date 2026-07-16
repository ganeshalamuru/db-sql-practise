SELECT o.order_id, o.ordered_at, o.status
FROM orders AS o
WHERE EXISTS (SELECT 1 FROM order_items AS oi WHERE oi.order_id = o.order_id)
  AND 2 <= ALL (
      SELECT oi.quantity FROM order_items AS oi WHERE oi.order_id = o.order_id
  )
ORDER BY o.ordered_at DESC, o.order_id DESC;
