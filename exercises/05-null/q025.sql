-- Task (Q025): Return review_id, product_id, customer_id, rating, and review_text. Replace a NULL review body with the text No written review.
-- Requirement: Order by review_id ascending.
 select review_id,product_id,customer_id,rating,coalesce(body,'No written review') as review_text
 from reviews
 order by review_id
