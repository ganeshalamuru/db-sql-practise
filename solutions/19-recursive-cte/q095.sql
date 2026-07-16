WITH RECURSIVE category_hierarchy AS (
    SELECT c.category_id AS root_category_id, c.name AS root_category_name,
           c.category_id, c.name AS category_name, 0 AS hierarchy_level
    FROM categories AS c
    WHERE c.parent_category_id IS NULL

    UNION ALL

    SELECT parent.root_category_id, parent.root_category_name,
           child.category_id, child.name, parent.hierarchy_level + 1
    FROM category_hierarchy AS parent
    JOIN categories AS child ON child.parent_category_id = parent.category_id
)
SELECT h.root_category_id, h.root_category_name,
       h.category_id, h.category_name, h.hierarchy_level,
       COUNT(p.product_id) AS active_product_count
FROM category_hierarchy AS h
LEFT JOIN products AS p ON p.category_id = h.category_id AND p.is_active
GROUP BY h.root_category_id, h.root_category_name,
         h.category_id, h.category_name, h.hierarchy_level
ORDER BY h.root_category_id, h.hierarchy_level, h.category_id;
