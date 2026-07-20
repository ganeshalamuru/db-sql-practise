-- Task (Q106): Return category_id, category_name, parent_category_id, hierarchy_level, and category_path for every category. hierarchy_level is 0 for root categories. category_path contains names from the root to the category separated by ' > '. Use string construction as part of the recursive traversal.
-- Requirement: Order by category_path ascending, then category_id ascending.
WITH RECURSIVE category_paths AS (
    SELECT c.category_id,
           c.name AS category_name,
           c.parent_category_id,
           0 AS hierarchy_level,
           c.name::TEXT AS category_path
    FROM categories AS c
    WHERE c.parent_category_id IS NULL

    UNION ALL

    SELECT child.category_id,
           child.name AS category_name,
           child.parent_category_id,
           parent.hierarchy_level + 1,
           CONCAT_WS(' > ', parent.category_path, child.name) AS category_path
    FROM category_paths AS parent
    JOIN categories AS child ON child.parent_category_id = parent.category_id
)
SELECT category_id,
       category_name,
       parent_category_id,
       hierarchy_level,
       category_path
FROM category_paths
ORDER BY category_path, category_id;
