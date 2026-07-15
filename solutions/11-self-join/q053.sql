SELECT c.category_id,
       c.name AS category_name,
       p.category_id AS parent_category_id,
       p.name AS parent_category_name
FROM categories AS c
LEFT JOIN categories AS p ON p.category_id = c.parent_category_id
ORDER BY parent_category_name NULLS FIRST, category_name, c.category_id;
