-- Task (Q140): Insert store inventory records for product_id 11 at every store that does not already stock that product. Each inserted record must have quantity_on_hand 25. Return store_id, product_id, and quantity_on_hand for each inserted store inventory record.
-- Requirement: No ordering is required.
INSERT INTO store_inventory (store_id, product_id, quantity_on_hand)
SELECT s.store_id,
       11,
       25
FROM stores AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM store_inventory AS si
    WHERE si.store_id = s.store_id
      AND si.product_id = 11
)
RETURNING store_id, product_id, quantity_on_hand;
