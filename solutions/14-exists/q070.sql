-- Task (Q070): Return warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory rows that are at or below their reorder point and have no matching store_inventory row with a positive quantity_on_hand for the same product.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
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
