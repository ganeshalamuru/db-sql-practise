 select review_id,product_id,customer_id,rating,coalesce(body,'No written review') as review_text
 from reviews
 order by review_id