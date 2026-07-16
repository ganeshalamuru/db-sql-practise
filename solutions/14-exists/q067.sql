SELECT p.product_id, p.sku, p.name
FROM products AS p
WHERE p.is_active
  AND NOT EXISTS (SELECT 1 FROM reviews AS r WHERE r.product_id = p.product_id)
ORDER BY p.product_id;
