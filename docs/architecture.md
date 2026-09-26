# Architecture & Multi-Database Engine Support

## Overview

The exercise catalog (`exercise_catalog.json`) is the central source of truth for all curriculum metadata. `scripts/build_problems.py` compiles catalog metadata into student-facing Markdown files and `exercise_registry.json`, which `grader.py` consumes to evaluate exercises.

The project is structured with a flexible database adapter abstraction layer that decouples the curriculum, seed generator, database setup, and grading engine from any specific SQL database engine. On this branch, the primary targeted database is **Microsoft SQL Server (T-SQL)**.

## Architecture Components

### 1. Database Adapter Layer (`db/`)

The database interface is formalized through `DatabaseAdapter` in `db/base.py`:
- `DatabaseAdapter`: Abstract base class defining engine capabilities:
  - `dialect_name`: Engine identifier (`sqlserver`, `postgres`).
  - `schema_filename`: Dialect-specific schema file name (`schema.sqlserver.sql`, `schema.sql`).
  - `connect(database, autocommit)`: Dialect-specific database connection.
  - `database_exists(database)` / `create_or_replace_database(database, recreate)`: Database management.
  - `schema_is_present(connection)` / `seed_data_is_present(connection)`: Health & state inspection.
  - `execute_script(connection, script_text)`: Multi-statement batch or script execution.
  - `execute_query(connection, query, read_only)`: Result set execution returning `QueryResult(columns, rows)`.
  - `grading_transaction(connection)`: Transaction context manager providing safe rollback sandboxing.
- `SqlServerAdapter` (`db/sqlserver.py`):
  - Uses `pyodbc` with Windows Authentication (`Trusted_Connection=yes;TrustServerCertificate=yes;`) as default.
  - Custom `split_sql_statements` parser to support SQL Server-specific batch separation rules (e.g. `CREATE OR ALTER VIEW` must be the first statement in a batch; multi-statement DDL/DML batches).
  - Explicit transaction sandboxing (`BEGIN TRANSACTION` and `IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION`).
- `PostgresAdapter` (`db/postgres.py`):
  - Encapsulates `psycopg` connection, transactional execution, and PostgreSQL catalog inspection.
- Factory (`db/__init__.py`):
  - `get_adapter(dialect, dsn, password)`: Returns the active adapter based on explicit parameter, `SQL_PRACTICE_DIALECT` env var, or defaults to `sqlserver`.

### 2. Schema Definitions

- `schema.sqlserver.sql`:
  - `BIGINT IDENTITY(1,1)` primary keys.
  - `BIT NOT NULL DEFAULT 1` for flags.
  - `DATETIME2` with `SYSUTCDATETIME()` defaults for timestamps.
  - `VARCHAR(255)` for unique keys and codes, `NVARCHAR(MAX)` for long bodies.
  - Filtered indexes (`WHERE is_active = 1`).
- `schema.sql`:
  - PostgreSQL schema using `BIGINT GENERATED ALWAYS AS IDENTITY`, `BOOLEAN`, `TIMESTAMPTZ`, and `TEXT`.

### 3. Data Generation (`generate_data.py`)

- Deterministic dataset generator with `--scale dev` and `--scale full`.
- Dialect awareness via `--dialect {sqlserver,postgres}`:
  - Emits `1` and `0` for SQL Server `BIT` columns vs `TRUE`/`FALSE` for PostgreSQL `BOOLEAN`.
  - Batches multi-row `INSERT` statements to a maximum of 990 rows to stay well under SQL Server's 1000-row `VALUES` table value constructor limit.
  - Wraps insertions in transactional batches.

### 4. Grader (`grader.py`)

- Evaluates solutions against student answers without text comparison.
- Sandboxes every grading attempt in an isolated transaction rollback block.
- Compares column names, row counts, duplicate multiplicity, ordering, NULL handling, and float tolerances.
- Supports dialect-specific solution resolution (e.g., looking for `.sqlserver.sql` if present, falling back to base `.sql`).

### 5. T-SQL Specific Curriculum (Module 33: `33-tsql-features`)

Module 33 teaches Microsoft SQL Server-specific features:
- **Q161**: `TOP (n) WITH TIES` for handling rank cutoffs with tied rows.
- **Q162**: `CROSS APPLY` for correlated table expressions (e.g. top N items per group).
- **Q163**: Conditional aggregation using `CASE` inside aggregates.
- **Q164**: `OUTER APPLY` for preserving parent rows without matching child expressions.
- **Q165**: `STRING_SPLIT` with `enable_ordinal = 1` for parsing delimited lists with ordinal positions.
