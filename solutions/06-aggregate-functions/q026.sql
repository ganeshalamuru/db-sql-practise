SELECT COUNT(*) FILTER (WHERE status = 'active') AS active_customer_count,
       COUNT(*) FILTER (WHERE status = 'suspended') AS suspended_customer_count,
       COUNT(*) FILTER (WHERE status = 'closed') AS closed_customer_count
FROM customers;
