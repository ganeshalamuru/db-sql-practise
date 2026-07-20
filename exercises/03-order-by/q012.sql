-- Task (Q012): Return supplier_id, name, and contact_email for all suppliers.
-- Requirement: Order by name ascending, then supplier_id ascending.
select supplier_id,name,contact_email
from suppliers
order by name,supplier_id desc
