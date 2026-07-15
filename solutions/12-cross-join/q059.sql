SELECT w.warehouse_id,
       w.code AS warehouse_code,
       p.product_id,
       p.sku,
       p.unit_price
FROM warehouses AS w
CROSS JOIN products AS p
WHERE p.is_active
  AND p.unit_price >= 1000.00
ORDER BY w.warehouse_id, p.product_id;
