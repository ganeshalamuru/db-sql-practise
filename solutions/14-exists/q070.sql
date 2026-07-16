SELECT w.warehouse_id, w.code AS warehouse_code, i.product_id, p.sku,
       i.quantity_on_hand, i.reorder_point
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.quantity_on_hand <= i.reorder_point
  AND NOT EXISTS (
      SELECT 1 FROM store_inventory AS si
      WHERE si.product_id = i.product_id AND si.quantity_on_hand > 0
  )
ORDER BY w.warehouse_id, i.product_id;
