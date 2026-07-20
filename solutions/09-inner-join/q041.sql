-- Task (Q041): Return product_id, product_name, supplier_name, and unit_price for active products.
-- Requirement: Order by supplier_name ascending, then product_name ascending, then product_id ascending.
SELECT p.product_id,
       p.name AS product_name,
       s.name AS supplier_name,
       p.unit_price
FROM products AS p
JOIN suppliers AS s ON s.supplier_id = p.supplier_id
WHERE p.is_active
ORDER BY supplier_name, product_name, p.product_id;
