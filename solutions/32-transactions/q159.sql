-- Task (Q159): Start a transaction and transfer 25 units of product_id 1 from warehouse_id 1 to warehouse_id 2. Return warehouse_id, product_id, and quantity_on_hand for those two inventory rows before rolling back the transaction.
-- Requirement: Order by warehouse_id ascending.
BEGIN TRANSACTION;

UPDATE inventory
SET quantity_on_hand = quantity_on_hand - 25
WHERE warehouse_id = 1
  AND product_id = 1;

UPDATE inventory
SET quantity_on_hand = quantity_on_hand + 25
WHERE warehouse_id = 2
  AND product_id = 1;

SELECT warehouse_id, product_id, quantity_on_hand
FROM inventory
WHERE product_id = 1
  AND warehouse_id IN (1, 2)
ORDER BY warehouse_id;

ROLLBACK TRANSACTION;
