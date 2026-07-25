-- Task (Q154): Add a constraint named shipments_delivered_at_required that requires delivered_at to be non-NULL whenever a shipment status is delivered. Return constraint_name, constraint_type, and constraint_definition for shipments_delivered_at_required.
-- Requirement: No ordering is required.
ALTER TABLE shipments
ADD CONSTRAINT shipments_delivered_at_required
CHECK (status <> 'delivered' OR delivered_at IS NOT NULL);

SELECT con.conname AS constraint_name,
       con.contype AS constraint_type,
       pg_get_constraintdef(con.oid) AS constraint_definition
FROM pg_constraint AS con
WHERE con.conrelid = 'shipments'::regclass
  AND con.conname = 'shipments_delivered_at_required';
