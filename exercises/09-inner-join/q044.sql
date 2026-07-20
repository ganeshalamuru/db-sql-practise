select 
    r.review_id,
    p.name as product_name,
    c.customer_id,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name,
    r.rating,
    r.created_at

from reviews as r join customers as c on r.customer_id=c.customer_id
join products as p on r.product_id = p.product_id

where r.rating BETWEEN 4 and 5
order by r.created_at desc,r.review_id desc