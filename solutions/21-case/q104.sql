-- Task (Q104): Return supplier_id, supplier_name, active_product_count, returned_active_product_count, and return_exposure for every supplier. returned_active_product_count is the number of distinct active products from that supplier that appear in returns. return_exposure is no_active_product_returns when the returned count is 0, broad_return_exposure when it is at least the active_product_count, and limited_return_exposure otherwise.
-- Requirement: Order by return_exposure ascending, then supplier_id ascending.
WITH active_product_counts AS (
    SELECT s.supplier_id,
           COUNT(p.product_id) AS active_product_count
    FROM suppliers AS s
    LEFT JOIN products AS p
        ON p.supplier_id = s.supplier_id
       AND p.is_active
    GROUP BY s.supplier_id
), returned_active_product_counts AS (
    SELECT p.supplier_id,
           COUNT(DISTINCT r.product_id) AS returned_active_product_count
    FROM products AS p
    JOIN returns AS r ON r.product_id = p.product_id
    WHERE p.is_active
    GROUP BY p.supplier_id
)
SELECT s.supplier_id,
       s.name AS supplier_name,
       a.active_product_count,
       COALESCE(r.returned_active_product_count, 0) AS returned_active_product_count,
       CASE
           WHEN COALESCE(r.returned_active_product_count, 0) = 0
               THEN 'no_active_product_returns'
           WHEN r.returned_active_product_count >= a.active_product_count
               THEN 'broad_return_exposure'
           ELSE 'limited_return_exposure'
       END AS return_exposure
FROM suppliers AS s
JOIN active_product_counts AS a ON a.supplier_id = s.supplier_id
LEFT JOIN returned_active_product_counts AS r ON r.supplier_id = s.supplier_id
ORDER BY return_exposure, s.supplier_id;
