-- Task (Q037): Return warehouse_id and total_units_on_hand for warehouses whose total quantity_on_hand is greater than 50,000.
-- Requirement: Order by total_units_on_hand descending, then warehouse_id ascending.
select 
    warehouse_id,
    sum(quantity_on_hand) as total_units_on_hand
from inventory
group by warehouse_id
having sum(quantity_on_hand)>50000
order by total_units_on_hand desc,warehouse_id
