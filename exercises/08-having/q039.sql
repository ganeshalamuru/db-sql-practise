-- Task (Q039): Return supplier_id and active_product_count for suppliers with at least 10 active products. Exclude inactive products before forming groups.
-- Requirement: Order by active_product_count descending, then supplier_id ascending.
select
    supplier_id,
    count(*) as active_product_count
from products
where is_active=true
group by supplier_id
having count(*)>=10
order by active_product_count desc,supplier_id
