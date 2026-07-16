SELECT c.category_id, c.name AS category_name, COUNT(p.product_id) AS active_product_count
FROM categories AS c
JOIN products AS p ON p.category_id = c.category_id AND p.is_active
WHERE c.category_id IN (
    SELECT reviewed.category_id
    FROM products AS reviewed
    JOIN reviews AS r ON r.product_id = reviewed.product_id
    JOIN customers AS cu ON cu.customer_id = r.customer_id
    JOIN cities AS ci ON ci.city_id = cu.city_id
    JOIN countries AS co ON co.country_id = ci.country_id
    WHERE co.name = 'India'
)
GROUP BY c.category_id, c.name
HAVING COUNT(p.product_id) >= 2
ORDER BY active_product_count DESC, c.category_id;
