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

import psycopg
from psycopg import sql


ROOT = Path(__file__).resolve().parent
LOGGER = logging.getLogger(__name__)


def database_exists(connection: psycopg.Connection[object], database: str) -> bool:
    return connection.execute("SELECT 1 FROM pg_database WHERE datname = %s", (database,)).fetchone() is not None


def connect(database: str, password: str | None, *, autocommit: bool = False) -> psycopg.Connection[object]:
    """Connect as the lab's PostgreSQL role without embedding a password in a DSN."""
    return psycopg.connect(
        host="localhost",
        port=5432,
        dbname=database,
        user="postgres",
        password=password,
        autocommit=autocommit,
    )


def create_or_replace_database(database: str, recreate: bool, password: str | None) -> bool:
    """Return True when a database was newly created."""
    with connect("postgres", password, autocommit=True) as connection:
        exists = database_exists(connection, database)
        if exists and recreate:
            connection.execute("SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = %s AND pid <> pg_backend_pid()", (database,))
            connection.execute(sql.SQL("DROP DATABASE {};").format(sql.Identifier(database)))
            exists = False
        if not exists:
            connection.execute(sql.SQL("CREATE DATABASE {};").format(sql.Identifier(database)))
            return True
    return False


def schema_is_present(connection: psycopg.Connection[object]) -> bool:
    return connection.execute("SELECT to_regclass('public.countries')").fetchone()[0] is not None


def seed_data_is_present(connection: psycopg.Connection[object]) -> bool:
    return connection.execute("SELECT EXISTS (SELECT 1 FROM countries)").fetchone()[0]


def initialize(database: str, scale: str, password: str | None) -> None:
    with connect(database, password) as connection:
        if schema_is_present(connection):
            if seed_data_is_present(connection):
                LOGGER.info("Schema and seed data already exist; preserving rows.")
                return
            LOGGER.info("Schema exists but has no seed data; loading it now.")
        else:
            LOGGER.info("Creating schema.")
            connection.execute((ROOT / "schema.sql").read_text(encoding="utf-8"))
            connection.commit()
    data_path = ROOT / "data.sql"
    LOGGER.info("Generating %s dataset at %s.", scale, data_path.name)
    subprocess.run([sys.executable, str(ROOT / "generate_data.py"), "--scale", scale, "--output", str(data_path)], check=True)
    with connect(database, password) as connection:
        LOGGER.info("Loading generated data.")
        connection.execute(data_path.read_text(encoding="utf-8"))
        connection.commit()


def main() -> int:
    parser = argparse.ArgumentParser(description="Set up the PostgreSQL SQL practice database.")
    modes = parser.add_mutually_exclusive_group()
    modes.add_argument("--recreate", action="store_true", help="Drop the database and rebuild it from scratch.")
    modes.add_argument("--append", action="store_true", help="Preserve an existing initialized database (the default).")
    parser.add_argument("--database", default="sql_practice")
    parser.add_argument("--scale", choices=("dev", "full"), default="dev")
    parser.add_argument(
        "--password",
        default=os.getenv("PGPASSWORD"),
        help="Password for the postgres role (defaults to the PGPASSWORD environment variable).",
    )
    args = parser.parse_args()
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", args.database):
        parser.error("--database must contain only letters, digits, and underscores.")
    logging.basicConfig(level=logging.INFO, format="%(message)s")
    created = create_or_replace_database(args.database, args.recreate, args.password)
    if created or args.recreate:
        initialize(args.database, args.scale, args.password)
    else:
        initialize(args.database, args.scale, args.password)
        LOGGER.info("Append mode left the existing database and rows intact.")
    LOGGER.info("Database '%s' is ready.", args.database)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
