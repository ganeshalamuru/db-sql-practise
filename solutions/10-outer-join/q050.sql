-- Task (Q050): Return product_id, product_name, and open_return_count for every active product. Count only returns whose status is requested or approved, and include products with no such returns.
-- Requirement: Order by open_return_count descending, then product_id ascending.
SELECT p.product_id, p.name AS product_name, COUNT(r.return_id) AS open_return_count
FROM products AS p
LEFT JOIN returns AS r
    ON r.product_id = p.product_id
   AND r.status IN ('requested', 'approved')
WHERE p.is_active
GROUP BY p.product_id, p.name
ORDER BY open_return_count DESC, p.product_id;
