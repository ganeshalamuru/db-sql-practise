-- Task (Q034): Return product_id, review_count, and average_rating for each reviewed product. average_rating must be rounded to two decimal places.
-- Requirement: Order by average_rating descending, then review_count descending, then product_id ascending.
select 
    product_id,
    count(*) as review_count,
    round(avg(rating),2) as average_rating
from reviews
group by product_id
order by average_rating desc,review_count desc,product_id
