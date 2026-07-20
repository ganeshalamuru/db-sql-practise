select 
    c.country_code,
    c.name as country_name,
    pm.payment_method

from countries as c cross join (VALUES ('card'), ('wallet'), ('bank_transfer'),('cash_on_delivery')) as pm(payment_method)
order by country_code,payment_method