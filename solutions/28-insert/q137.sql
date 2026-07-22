-- Task (Q137): Insert an active product with supplier_id 1, category_id 1, sku 'SKU-PRACTICE-INSERT-137', name 'Practice Insert Product', unit_price 49.99, and created_at '2024-01-15 09:00:00+00'. Return sku, name, unit_price, is_active, and created_at for the inserted product.
-- Requirement: No ordering is required.
INSERT INTO products (
    supplier_id,
    category_id,
    sku,
    name,
    unit_price,
    is_active,
    created_at
)
VALUES (
    1,
    1,
    'SKU-PRACTICE-INSERT-137',
    'Practice Insert Product',
    49.99,
    TRUE,
    '2024-01-15 09:00:00+00'
)
RETURNING sku, name, unit_price, is_active, created_at;
