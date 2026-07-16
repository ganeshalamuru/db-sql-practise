# Seed-data exercise coverage

The deterministic dataset is a teaching fixture, not merely a collection of
plausible retail records. Both `dev` and `full` scales must give every released
official solution a non-empty result, and exercises that teach an edge case
must contain rows on both sides of that edge case.

The generator deliberately includes the following contrasts:

- Customers with and without orders; suppliers with and without active products;
  and active products with and without reviews or open returns.
- A warehouse with no inventory rows, while the other warehouses have inventory.
  This makes the `LEFT JOIN` and `COALESCE` in Q049 observable rather than
  cosmetic.
- Returns in every valid status, including requested and approved returns, so
  Q050's conditional count has positive counts as well as zeroes.
- Low-stock products that are unavailable at all stores, alongside products
  that have store stock, for `NOT EXISTS` exercises.
- All customer, order, payment, and shipment statuses; promotions; failed
  payments; nullable review text; and both delivered and undelivered shipments.
- Products, suppliers, order quantities, prices, and ratings that intentionally
  meet the released `HAVING`, `ANY`, `ALL`, and subquery thresholds.

When adding an exercise, update `generate_data.py` whenever its filters,
thresholds, or outer-join condition would otherwise produce an empty or
one-sided result. Regenerate `data.sql` with `python generate_data.py --scale
dev` after changing the generator.

Run `python scripts/verify_data_coverage.py --password YOUR_PASSWORD` against
an initialized lab database to check every official solution. Redirect both
streams to retain the complete report, for example:

```powershell
python scripts/verify_data_coverage.py --password YOUR_PASSWORD *> coverage-report.txt
```
