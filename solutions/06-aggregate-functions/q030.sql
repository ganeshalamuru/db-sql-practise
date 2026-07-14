SELECT
    MIN(ordered_at) AS first_ordered_at,
    MAX(ordered_at) AS last_ordered_at
FROM orders;
