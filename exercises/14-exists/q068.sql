-- Task (Q068): Return supplier_id, supplier_name, product_id, product_name, and unit_price for active products from suppliers that also supply at least one other active product priced above 1,000.00.
-- Requirement: Order by supplier_id ascending, then product_id ascending.
select 
    p.supplier_id,
    s.name as supplier_name,
    p.product_id,
    p.name as product_name,
    p.unit_price
from products as p join suppliers as s on p.supplier_id = s.supplier_id and p.is_active
where exists (select product_id from products as pp where pp.supplier_id=p.supplier_id and pp.product_id!=p.product_id and pp.unit_price>1000.00)
order by p.supplier_id,p.product_id