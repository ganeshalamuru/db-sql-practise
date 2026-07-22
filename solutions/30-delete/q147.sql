-- Task (Q147): Delete store inventory records for inactive products. Return store_id, product_id, and quantity_on_hand for each deleted inventory record.
-- Requirement: No ordering is required.
DELETE FROM store_inventory AS si
USING products AS p
WHERE si.product_id = p.product_id
  AND NOT p.is_active
RETURNING si.store_id, si.product_id, si.quantity_on_hand;
