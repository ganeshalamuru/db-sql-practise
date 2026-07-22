-- Task (Q067): Return product_id, sku, and name for active products that have never received a review.
-- Requirement: Order by product_id ascending.
select 
    product_id,
    sku,
    name
from products as p
where is_active and not exists (select review_id from reviews as r where r.product_id=p.product_id)
order by product_id