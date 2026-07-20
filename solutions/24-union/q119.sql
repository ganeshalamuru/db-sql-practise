WITH available_product_ids AS (
    SELECT i.product_id
    FROM inventory AS i
    WHERE i.quantity_on_hand > 0

    UNION

    SELECT si.product_id
    FROM store_inventory AS si
    WHERE si.quantity_on_hand > 0
)
SELECT p.product_id,
       p.sku,
       p.name
FROM products AS p
JOIN available_product_ids AS a ON a.product_id = p.product_id
WHERE p.is_active
ORDER BY p.product_id;
