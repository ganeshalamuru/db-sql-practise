select
    supplier_id,
    count(*) as active_product_count
from products
where is_active=true
group by supplier_id
having count(*)>=10
order by active_product_count desc,supplier_id