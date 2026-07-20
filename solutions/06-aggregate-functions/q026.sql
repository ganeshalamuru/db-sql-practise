-- Task (Q026): Return active_customer_count, suspended_customer_count, and closed_customer_count: the number of customers in each respective status.
-- Requirement: The result has one row; no ordering is needed.
SELECT COUNT(*) FILTER (WHERE status = 'active') AS active_customer_count,
       COUNT(*) FILTER (WHERE status = 'suspended') AS suspended_customer_count,
       COUNT(*) FILTER (WHERE status = 'closed') AS closed_customer_count
FROM customers;
