-- Task (Q060): Return country_code, country_name, and payment_method for every country-and-payment-method combination. The payment methods are card, wallet, bank_transfer, and cash_on_delivery.
-- Requirement: Order by country_code ascending, then payment_method ascending.
select 
    c.country_code,
    c.name as country_name,
    pm.payment_method

from countries as c cross join (VALUES ('card'), ('wallet'), ('bank_transfer'),('cash_on_delivery')) as pm(payment_method)
order by country_code,payment_method
