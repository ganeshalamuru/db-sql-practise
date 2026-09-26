-- Task (Q133): Create or replace a view named vw_product_review_summary that returns product_id, sku, review_count, and average_rating for products with at least one review. average_rating is the average review rating. Then return every row from vw_product_review_summary.
-- Requirement: Order by review_count descending, then product_id ascending.
CREATE OR ALTER VIEW vw_supplier_active_products AS
SELECT s.supplier_id,
       s.name,
       COUNT(p.product_id) AS active_product_count,
       COALESCE(SUM(p.unit_price), 0) AS total_active_catalog_value
FROM suppliers AS s
LEFT JOIN products AS p
    ON p.supplier_id = s.supplier_id
   AND p.is_active = 1
GROUP BY s.supplier_id, s.name;

SELECT supplier_id,
       name,
       active_product_count,
       total_active_catalog_value
FROM vw_supplier_active_products
ORDER BY supplier_id;
