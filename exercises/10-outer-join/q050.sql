-- Task (Q050): Return product_id, product_name, and open_return_count for every active product. Count only returns whose status is requested or approved, and include products with no such returns.
-- Requirement: Order by open_return_count descending, then product_id ascending.
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
