SELECT p.product_id,
       p.name AS product_name,
       s.name AS supplier_name,
       p.unit_price
FROM products AS p
JOIN suppliers AS s ON s.supplier_id = p.supplier_id
WHERE p.is_active
ORDER BY supplier_name, product_name, p.product_id;
