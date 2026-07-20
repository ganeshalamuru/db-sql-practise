-- Task (Q053): Return category_id, category_name, parent_category_id, and parent_category_name for every category, including root categories with no parent.
-- Requirement: Order by parent_category_name ascending with NULL values first, then category_name ascending, then category_id ascending.
select 
    c.category_id,
    c.name as category_name,
    c.parent_category_id,
    p.name as parent_category_name
from categories as c left join categories as p on c.parent_category_id = p.category_id
order by parent_category_name asc nulls first,category_name,c.category_id
