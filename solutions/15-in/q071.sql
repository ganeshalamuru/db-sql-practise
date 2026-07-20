-- Task (Q071): Return product_id, sku, name, and unit_price for products supplied by suppliers located in the same country as the customer whose email is 'customer1@example.test'.
-- Requirement: Order by product_id ascending.
SELECT p.product_id, p.sku, p.name, p.unit_price
FROM products AS p
WHERE p.supplier_id IN (
    SELECT s.supplier_id
    FROM suppliers AS s
    WHERE s.country_id IN (
        SELECT c.country_id
        FROM customers AS cu
        JOIN cities AS c ON c.city_id = cu.city_id
        WHERE cu.email = 'customer1@example.test'
    )
)
ORDER BY p.product_id;
