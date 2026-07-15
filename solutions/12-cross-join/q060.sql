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
