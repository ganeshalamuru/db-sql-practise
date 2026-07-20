-- Task (Q129): Return supplier_id, supplier_name, active_product_count, and average_active_unit_price for suppliers that have at least one active product but no active product appearing in returns.
-- Requirement: Order by average_active_unit_price descending, then supplier_id ascending.
WITH suppliers_with_active_products AS (
    SELECT supplier_id
    FROM products
    WHERE is_active
), suppliers_with_returned_active_products AS (
    SELECT p.supplier_id
    FROM products AS p
    JOIN returns AS r ON r.product_id = p.product_id
    WHERE p.is_active
), qualifying_supplier_ids AS (
    SELECT supplier_id FROM suppliers_with_active_products
    EXCEPT
    SELECT supplier_id FROM suppliers_with_returned_active_products
), active_product_metrics AS (
    SELECT supplier_id,
           COUNT(product_id) AS active_product_count,
           AVG(unit_price) AS average_active_unit_price
    FROM products
    WHERE is_active
    GROUP BY supplier_id
)
SELECT s.supplier_id,
       s.name AS supplier_name,
       m.active_product_count,
       m.average_active_unit_price
FROM qualifying_supplier_ids AS q
JOIN suppliers AS s ON s.supplier_id = q.supplier_id
JOIN active_product_metrics AS m ON m.supplier_id = q.supplier_id
ORDER BY m.average_active_unit_price DESC, s.supplier_id;
