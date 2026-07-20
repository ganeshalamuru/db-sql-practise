-- Task (Q040): Return product_id, review_count, and average_rating for products that have at least 5 reviews and an average review rating of at least 4.00. Round average_rating to two decimal places.
-- Requirement: Order by average_rating descending, then review_count descending, then product_id ascending.
select
    product_id,
    count(*) as review_count,
    round(avg(rating),2) as average_rating
from reviews
group by product_id
having count(*) >= 5 and avg(rating)>=4.00
order by average_rating desc,review_count desc,product_id
