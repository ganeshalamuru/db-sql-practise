select
    s.supplier_id,
    s.name as supplier_name,
    c.category_id,
    c.name as category_name

from suppliers as s cross join categories as c
order by supplier_id,category_id