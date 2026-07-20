-- Task (Q058): Return supplier_id, supplier_name, category_id, and category_name for every possible supplier-and-category combination.
-- Requirement: Order by supplier_id ascending, then category_id ascending.
SELECT s.supplier_id,
       s.name AS supplier_name,
       c.category_id,
       c.name AS category_name
FROM suppliers AS s
CROSS JOIN categories AS c
ORDER BY s.supplier_id, c.category_id;
