"""Create and initialize the SQL practice database.

Use --recreate for a clean lab database. Use --append to preserve an existing
database; it initializes only an empty database and never overwrites data.
"""
from __future__ import annotations

import argparse
import logging
import os
import re
import subprocess
import sys
from pathlib import Path

from config import DatabaseConfig
from db import DatabaseAdapter, get_adapter

ROOT = Path(__file__).resolve().parent
LOGGER = logging.getLogger(__name__)


def initialize(adapter: DatabaseAdapter, database: str, scale: str) -> None:
    schema_file = ROOT / adapter.schema_filename
    if not schema_file.exists():
        raise FileNotFoundError(f"Schema file '{schema_file.name}' not found for dialect '{adapter.dialect_name}'.")

    with adapter.connect(database) as connection:
        if adapter.schema_is_present(connection):
            if adapter.seed_data_is_present(connection):
                LOGGER.info("Schema and seed data already exist; preserving rows.")
                return
            LOGGER.info("Schema exists but has no seed data; loading it now.")
        else:
            LOGGER.info("Creating schema using %s.", schema_file.name)
            adapter.execute_script(connection, schema_file.read_text(encoding="utf-8"))

    data_path = ROOT / "data.sql"
    LOGGER.info("Generating %s dataset at %s for dialect '%s'.", scale, data_path.name, adapter.dialect_name)
    subprocess.run(
        [
            sys.executable,
            str(ROOT / "generate_data.py"),
            "--scale",
            scale,
            "--dialect",
            adapter.dialect_name,
            "--output",
            str(data_path),
        ],
        check=True,
    )
    with adapter.connect(database) as connection:
        LOGGER.info("Loading generated data.")
        adapter.execute_script(connection, data_path.read_text(encoding="utf-8"))


def main() -> int:
    config = DatabaseConfig.from_environment()
    parser = argparse.ArgumentParser(description="Set up the SQL practice database.")
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--recreate", action="store_true", help="Drop the database and rebuild it from scratch.")
    modes.add_argument("--append", action="store_true", help="Preserve an existing initialized database (the default).")
    parser.add_argument(
        "--dialect",
        choices=("sqlserver", "postgres"),
        default=config.dialect,
        help="Database engine dialect (defaults to SQL_PRACTICE_DIALECT or sqlserver).",
    )
    parser.add_argument("--database", default="sql_practice")
    parser.add_argument("--scale", choices=("dev", "full"), default="dev")
    parser.add_argument("--dsn", default=None, help="Custom connection string or DSN.")
    parser.add_argument(
        "--password",
        default=config.password,
        help="Database password (defaults to PGPASSWORD / SQL_PASSWORD).",
    )
    args = parser.parse_args()
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", args.database):
        parser.error("--database must contain only letters, digits, and underscores.")

    logging.basicConfig(level=logging.INFO, format="%(message)s")
    adapter = get_adapter(args.dialect, args.dsn, args.password)

    created = adapter.create_or_replace_database(args.database, args.recreate)
    if created or args.recreate:
        initialize(adapter, args.database, args.scale)
    else:
        initialize(adapter, args.database, args.scale)
        LOGGER.info("Append mode left the existing database and rows intact.")
    LOGGER.info("Database '%s' (%s) is ready.", args.database, adapter.dialect_name)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
