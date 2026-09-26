-- Task (Q161): Return product_id, sku, name, and unit_price for the top 5 most expensive products. If there are ties for the 5th price, return all tied products using TOP WITH TIES.
-- Requirement: Order by unit_price descending, then product_id ascending.
SELECT TOP 5 WITH TIES product_id, sku, name, unit_price
FROM products
ORDER BY unit_price DESC, product_id;
