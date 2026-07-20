-- Task (Q060): Return country_code, country_name, and payment_method for every country-and-payment-method combination. The payment methods are card, wallet, bank_transfer, and cash_on_delivery.
-- Requirement: Order by country_code ascending, then payment_method ascending.
SELECT c.country_code, c.name AS country_name, pm.payment_method
FROM countries AS c
CROSS JOIN (
    VALUES
        ('card'),
        ('wallet'),
        ('bank_transfer'),
        ('cash_on_delivery')
) AS pm(payment_method)
ORDER BY c.country_code, pm.payment_method;
