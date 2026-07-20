SELECT c.email,
       CONCAT_WS(' ', c.first_name, c.last_name) AS contact_name,
       'customer'::TEXT AS contact_type,
       co.country_code
FROM customers AS c
LEFT JOIN cities AS ci ON ci.city_id = c.city_id
LEFT JOIN countries AS co ON co.country_id = ci.country_id

UNION ALL

SELECT s.contact_email AS email,
       s.name AS contact_name,
       'supplier'::TEXT AS contact_type,
       co.country_code
FROM suppliers AS s
LEFT JOIN countries AS co ON co.country_id = s.country_id

ORDER BY contact_type, email;
