select 
    c.category_id,
    c.name as category_name,
    c.parent_category_id,
    p.name as parent_category_name
from categories as c left join categories as p on c.parent_category_id = p.category_id
order by parent_category_name asc nulls first,category_name,c.category_id