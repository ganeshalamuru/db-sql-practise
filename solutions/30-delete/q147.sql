-- Task (Q147): Delete store inventory records for inactive products. Return store_id, product_id, and quantity_on_hand for each deleted inventory record.
-- Requirement: No ordering is required.
DELETE si
OUTPUT deleted.store_id, deleted.product_id, deleted.quantity_on_hand
FROM store_inventory AS si
JOIN products AS p ON p.product_id = si.product_id
WHERE p.is_active = 0;
