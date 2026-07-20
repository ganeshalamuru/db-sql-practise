-- Task (Q059): Return warehouse_id, warehouse_code, product_id, sku, and unit_price for every warehouse-and-product combination where the product is active and priced at least 1,000.00.
-- Requirement: Order by warehouse_id ascending, then product_id ascending.
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
