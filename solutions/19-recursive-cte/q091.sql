WITH RECURSIVE category_hierarchy AS (
    SELECT c.category_id, c.name AS category_name, c.parent_category_id,
           0 AS hierarchy_level, c.name::TEXT AS category_path
    FROM categories AS c
    WHERE c.parent_category_id IS NULL

    UNION ALL

    SELECT child.category_id, child.name, child.parent_category_id,
           parent.hierarchy_level + 1,
           parent.category_path || ' > ' || child.name
    FROM categories AS child
    JOIN category_hierarchy AS parent ON child.parent_category_id = parent.category_id
)
SELECT category_id, category_name, parent_category_id, hierarchy_level, category_path
FROM category_hierarchy
ORDER BY category_path, category_id;
