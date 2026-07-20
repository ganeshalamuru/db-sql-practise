-- Task (Q058): Return supplier_id, supplier_name, category_id, and category_name for every possible supplier-and-category combination.
-- Requirement: Order by supplier_id ascending, then category_id ascending.
select
    s.supplier_id,
    s.name as supplier_name,
    c.category_id,
    c.name as category_name

from suppliers as s cross join categories as c
order by supplier_id,category_id
