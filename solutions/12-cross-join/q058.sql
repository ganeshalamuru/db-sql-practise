SELECT s.supplier_id,
       s.name AS supplier_name,
       c.category_id,
       c.name AS category_name
FROM suppliers AS s
CROSS JOIN categories AS c
ORDER BY s.supplier_id, c.category_id;
