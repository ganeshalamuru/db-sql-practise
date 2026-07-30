-- Task (Q074): Return category_id, category_name, and active_product_count for categories that contain at least one active product reviewed by a customer from India. Include only categories with at least two active products.
-- Requirement: Order by active_product_count descending, then category_id ascending.
select 
    c.category_id,
    c.name as category_name,
    count(p.product_id) as active_product_count
from categories as c 
join products as p on c.category_id = p.category_id and p.is_active
group by c.category_id,category_name
having count(p.product_id) >= 2 and 
    count(p.product_id) FILTER (where p.product_id in 
    (select r.product_id 
        from reviews as r 
        join customers as c on r.review_id=c.customer_id 
        where c.city_id in (
            select ci.city_id 
            from cities as ci 
            join countries as co on ci.country_id=co.country_id
            where co.name = 'India'))) >=1 

order by active_product_count desc,c.category_id


