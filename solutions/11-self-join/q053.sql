-- Task (Q053): Return category_id, category_name, parent_category_id, and parent_category_name for every category, including root categories with no parent.
-- Requirement: Order by parent_category_name ascending with NULL values first, then category_name ascending, then category_id ascending.
SELECT c.category_id,
       c.name AS category_name,
       p.category_id AS parent_category_id,
       p.name AS parent_category_name
FROM categories AS c
LEFT JOIN categories AS p ON p.category_id = c.parent_category_id
ORDER BY parent_category_name NULLS FIRST, category_name, c.category_id;
