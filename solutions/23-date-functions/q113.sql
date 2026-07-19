SELECT w.warehouse_id,
       w.code AS warehouse_code,
       s.delivered_at::DATE AS delivery_date,
       COUNT(s.shipment_id) AS delivered_shipment_count,
       AVG(
           EXTRACT(EPOCH FROM s.delivered_at - s.shipped_at) / 86400.0
       ) AS average_delivery_days
FROM shipments AS s
JOIN warehouses AS w ON w.warehouse_id = s.warehouse_id
WHERE s.status = 'delivered'
GROUP BY w.warehouse_id, w.code, s.delivered_at::DATE
ORDER BY w.warehouse_id, delivery_date;
