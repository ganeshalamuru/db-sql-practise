-- Task (Q168): Return category_id, category_name, active_product_count, and active_inventory_units for every category. Count active products and sum the quantity_on_hand of those active products across warehouses without multiplying either metric through a direct products-to-inventory join. Use 0 when a category has no matching rows.
-- Requirement: Order by category_id ascending.
WITH active_product_counts AS (
    SELECT category_id,
           COUNT(*) AS active_product_count
    FROM products
    WHERE is_active = 1
    GROUP BY category_id
), active_inventory_totals AS (
    SELECT p.category_id,
           SUM(i.quantity_on_hand) AS active_inventory_units
    FROM products AS p
    JOIN inventory AS i ON i.product_id = p.product_id
    WHERE p.is_active = 1
    GROUP BY p.category_id
)
SELECT c.category_id,
       c.name AS category_name,
       COALESCE(apc.active_product_count, 0) AS active_product_count,
       COALESCE(ait.active_inventory_units, 0) AS active_inventory_units
FROM categories AS c
LEFT JOIN active_product_counts AS apc ON apc.category_id = c.category_id
LEFT JOIN active_inventory_totals AS ait ON ait.category_id = c.category_id
ORDER BY c.category_id;
