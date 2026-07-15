# SQL Practice Lab

A PostgreSQL-based SQL curriculum designed as a durable, metadata-driven learning lab. The first module ships with five `SELECT` exercises; future modules are added through the catalog instead of by hand-maintaining hundreds of files.

## Quick start

1. Install PostgreSQL 16+ and Python 3.12+.
2. Create and activate a virtual environment, then install dependencies: `python -m pip install -r requirements.txt`.
3. Run the complete setup with your PostgreSQL `postgres` role: `python setup_database.py --recreate --scale dev --password YOUR_PASSWORD`.
4. Render exercises: `python scripts/build_problems.py`.
5. The renderer creates a blank answer file for every exercise. Write your query in `answers/01-select/q001.sql`, then grade it: `python grader.py --problem Q001 --password YOUR_PASSWORD`.

Set `SQL_PRACTICE_DSN` if your PostgreSQL connection differs from the default `postgresql://postgres@localhost:5432/sql_practice`. `setup_database.py` accepts `--password`; alternatively set `PGPASSWORD` before running it so the password does not appear in shell history.

The grader accepts the same password option: `python grader.py --problem Q001 --password YOUR_PASSWORD`. With `PGPASSWORD` set, omit `--password` from both commands.

## Database setup modes

`python setup_database.py --recreate --scale dev --password YOUR_PASSWORD` terminates active connections, drops `sql_practice`, creates it again, loads `schema.sql`, generates `data.sql`, and loads that file. Use it when you want a clean start.

`python setup_database.py --append --scale dev --password YOUR_PASSWORD` preserves an existing initialized database and all of its rows. If the database does not exist, has no schema, or has a schema with no seed data, it initializes it. It does not re-import the deterministic seed into a populated database because that would create duplicate business records.

To use another database name, add `--database my_lab`. You can still run individual manual steps when useful:

```powershell
python generate_data.py --scale dev
psql -U postgres -d sql_practice -f data.sql
```

## Authoring exercises

Add structured metadata to `exercise_catalog.json`, create the matching instructor solution in `solutions/`, and run `python scripts/build_problems.py`. The renderer creates the Markdown problem statement and the registry automatically. Keep `solutions/` in a private instructor repository or release artifact if students must not see answers; GitHub cannot hide files committed to a public repository.

The renderer also creates missing blank files in the matching `answers/<topic>/` folder. Existing answer files are never overwritten.

## Dataset scales

`dev` is fast for local iteration. `full` targets approximately 5,000 customers, 2,000 products, 50,000 orders, and 250,000 order items. Both use the same fixed seed.

See [the architecture notes](docs/architecture.md) for component responsibilities.
The full sequence and release status are in the [curriculum roadmap](docs/curriculum.md).
