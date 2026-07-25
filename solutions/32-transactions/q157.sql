-- Task (Q157): Start a transaction, insert a supplier with name 'Transaction Practice Supplier', contact_email 'transaction-practice-supplier@example.test', and country_id 1. Return name, contact_email, and country_id for the inserted supplier before rolling back the transaction.
-- Requirement: No ordering is required.
BEGIN;

INSERT INTO suppliers (name, contact_email, country_id)
VALUES ('Transaction Practice Supplier', 'transaction-practice-supplier@example.test', 1);

SELECT name, contact_email, country_id
FROM suppliers
WHERE contact_email = 'transaction-practice-supplier@example.test';

ROLLBACK;
