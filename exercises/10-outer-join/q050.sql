select 
    p.product_id,
    p.name as product_name,
    count(r.return_id) as open_return_count
from products as p 
left join returns as r on p.product_id = r.product_id 
        and r.status in ('requested','approved')
where p.is_active
group by p.product_id,p.name
order by open_return_count desc, product_id