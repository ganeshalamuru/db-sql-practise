select 
    s.supplier_id,
    s.name as supplier_name,
    p.product_id,
    p.name as product_name,
    p.unit_price

from suppliers as s join products as p on s.supplier_id=p.supplier_id and p.is_active
where p.unit_price > (select avg(unit_price) from products as pp where pp.is_active and pp.supplier_id = s.supplier_id)
    and (select count(*) from products as ppp where ppp.is_active and ppp.supplier_id=s.supplier_id)>=2
order by s.supplier_id,p.unit_price desc,p.product_id
