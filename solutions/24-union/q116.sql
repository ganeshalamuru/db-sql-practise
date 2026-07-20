-- Task (Q116): Return email, contact_name, contact_type, and country_code for every customer and supplier. contact_name is the customer's first and last name joined with one space, or the supplier name. contact_type is customer or supplier. A customer country is determined through the customer's city; a supplier country is determined directly. Include all rows from both entity types.
-- Requirement: Order by contact_type ascending, then email ascending.
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
