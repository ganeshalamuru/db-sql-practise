-- Task (Q048): Return supplier_id, supplier_name, and active_product_count for every supplier, including suppliers with no active products.
-- Requirement: Order by active_product_count descending, then supplier_id ascending.
select
    s.supplier_id,
    s.name as supplier_name,
    count(p.product_id) as active_product_count

from suppliers as s left join products as p on s.supplier_id = p.supplier_id and p.is_active
group by s.supplier_id,s.name
order by active_product_count desc,supplier_id
