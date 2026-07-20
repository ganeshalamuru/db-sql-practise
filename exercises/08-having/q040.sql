select
    product_id,
    count(*) as review_count,
    round(avg(rating),2) as average_rating
from reviews
group by product_id
having count(*) >= 5 and avg(rating)>=4.00
order by average_rating desc,review_count desc,product_id