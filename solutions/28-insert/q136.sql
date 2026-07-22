-- Task (Q136): Insert a supplier with name 'Practice Insert Supplier', contact_email 'practice-insert-supplier@example.test', and country_id 1. Return name, contact_email, and country_id for the inserted supplier.
-- Requirement: No ordering is required.
INSERT INTO suppliers (name, contact_email, country_id)
VALUES ('Practice Insert Supplier', 'practice-insert-supplier@example.test', 1)
RETURNING name, contact_email, country_id;
