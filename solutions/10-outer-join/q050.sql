SELECT p.product_id, p.name AS product_name, COUNT(r.return_id) AS open_return_count
FROM products AS p
LEFT JOIN returns AS r
    ON r.product_id = p.product_id
   AND r.status IN ('requested', 'approved')
WHERE p.is_active
GROUP BY p.product_id, p.name
ORDER BY open_return_count DESC, p.product_id;
