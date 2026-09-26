-- Task (Q026): Return active_customer_count, suspended_customer_count, and closed_customer_count: the number of customers in each respective status.
-- Requirement: The result has one row; no ordering is needed.
SELECT COUNT(CASE WHEN status = 'active' THEN 1 END) AS active_customer_count,
       COUNT(CASE WHEN status = 'suspended' THEN 1 END) AS suspended_customer_count,
       COUNT(CASE WHEN status = 'closed' THEN 1 END) AS closed_customer_count
FROM customers;
