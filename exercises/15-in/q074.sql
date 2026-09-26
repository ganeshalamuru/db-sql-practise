-- Task (Q074): Return category_id, category_name, and active_product_count for categories that contain at least one active product reviewed by a customer from India. Include only categories with at least two active products.
-- Requirement: Order by active_product_count descending, then category_id ascending.
select 
    c.category_id,
    c.name as category_name,
    count(p.product_id) as active_product_count
from categories as c 
join products as p on c.category_id = p.category_id and p.is_active = 1
where c.category_id in (
    select reviewed.category_id
    from products as reviewed
    join reviews as r on r.product_id = reviewed.product_id
    join customers as cu on cu.customer_id = r.customer_id
    join cities as ci on ci.city_id = cu.city_id
    join countries as co on co.country_id = ci.country_id
    where co.name = 'India'
)
group by c.category_id, c.name
having count(p.product_id) >= 2
order by active_product_count desc, c.category_id
