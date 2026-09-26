-- Task (Q154): Add a constraint named shipments_delivered_at_required that requires delivered_at to be non-NULL whenever a shipment status is delivered. Return constraint_name, constraint_type, and constraint_definition for shipments_delivered_at_required.
-- Requirement: No ordering is required.
ALTER TABLE shipments
ADD CONSTRAINT shipments_delivered_at_required
CHECK (status <> 'delivered' OR delivered_at IS NOT NULL);

SELECT name AS constraint_name,
       type_desc AS constraint_type,
       definition AS constraint_definition
FROM sys.check_constraints
WHERE name = 'shipments_delivered_at_required';
