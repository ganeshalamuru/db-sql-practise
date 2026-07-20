select 
    p.product_id,
    p.name as product_name,
    count(r.review_id) as review_count
from products as p left join reviews as r on p.product_id = r.product_id
where p.is_active = true
group by p.product_id 
order by review_count desc,product_id
