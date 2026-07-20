-- Task (Q012): Return supplier_id, name, and contact_email for all suppliers.
-- Requirement: Order by name ascending, then supplier_id ascending.
SELECT supplier_id, name, contact_email
FROM suppliers
ORDER BY name, supplier_id;
