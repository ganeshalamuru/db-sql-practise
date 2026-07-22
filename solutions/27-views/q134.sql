-- Task (Q134): Create or replace a view named vw_low_stock_inventory that returns warehouse_id, warehouse_code, product_id, sku, quantity_on_hand, and reorder_point for inventory records whose quantity_on_hand is at or below reorder_point. Then return every row from vw_low_stock_inventory.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
CREATE OR REPLACE VIEW vw_low_stock_inventory AS
SELECT i.warehouse_id,
       w.code AS warehouse_code,
       i.product_id,
       p.sku,
       i.quantity_on_hand,
       i.reorder_point
FROM inventory AS i
JOIN warehouses AS w ON w.warehouse_id = i.warehouse_id
JOIN products AS p ON p.product_id = i.product_id
WHERE i.quantity_on_hand <= i.reorder_point;

SELECT warehouse_id,
       warehouse_code,
       product_id,
       sku,
       quantity_on_hand,
       reorder_point
FROM vw_low_stock_inventory
ORDER BY warehouse_id, product_id;
