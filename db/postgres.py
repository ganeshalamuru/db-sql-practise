"""PostgreSQL database adapter using psycopg."""
from __future__ import annotations

import logging
from contextlib import contextmanager
from typing import Any, Iterator

try:
    import psycopg
    from psycopg import sql
except ImportError:
    psycopg = None
    sql = None

from db.base import DatabaseAdapter, QueryResult

LOGGER = logging.getLogger(__name__)

DEFAULT_POSTGRES_DSN = "postgresql://postgres@localhost:5432/sql_practice"


class PostgresAdapter(DatabaseAdapter):
    def __init__(self, dsn: str | None = None, password: str | None = None):
        if psycopg is None:
            raise ImportError("psycopg is not installed. Install it with: pip install psycopg[binary]")
        self._dsn = dsn or DEFAULT_POSTGRES_DSN
        self._password = password

    @property
    def dialect_name(self) -> str:
        return "postgres"

    @property
    def schema_filename(self) -> str:
        return "schema.sql"

    def connect(self, database: str | None = None, *, autocommit: bool = False) -> psycopg.Connection[Any]:
        # If database is specified and DSN is standard, adjust dbname
        dsn = self._dsn
        if database:
            # Simple replacement if ends with /dbname or set dbname param
            import urllib.parse
            parsed = urllib.parse.urlparse(dsn)
            if parsed.scheme:
                new_path = f"/{database}"
                dsn = urllib.parse.urlunparse(parsed._replace(path=new_path))
        return psycopg.connect(
            dsn,
            password=self._password,
            autocommit=autocommit,
        )

    def database_exists(self, database: str) -> bool:
        with self.connect("postgres", autocommit=True) as conn:
            row = conn.execute("SELECT 1 FROM pg_database WHERE datname = %s", (database,)).fetchone()
            return row is not None

    def create_or_replace_database(self, database: str, recreate: bool) -> bool:
        with self.connect("postgres", autocommit=True) as conn:
            exists = self.database_exists(database)
            if exists and recreate:
                conn.execute(
                    "SELECT pg_terminate_backend(pid) FROM pg_stat_activity "
                    "WHERE datname = %s AND pid <> pg_backend_pid()",
                    (database,),
                )
                conn.execute(sql.SQL("DROP DATABASE {};").format(sql.Identifier(database)))
                exists = False
            if not exists:
                conn.execute(sql.SQL("CREATE DATABASE {};").format(sql.Identifier(database)))
                return True
        return False

    def schema_is_present(self, connection: psycopg.Connection[Any]) -> bool:
        row = connection.execute("SELECT to_regclass('public.countries')").fetchone()
        return row is not None and row[0] is not None

    def seed_data_is_present(self, connection: psycopg.Connection[Any]) -> bool:
        row = connection.execute("SELECT EXISTS (SELECT 1 FROM countries)").fetchone()
        return bool(row and row[0])

    def execute_script(self, connection: psycopg.Connection[Any], script_text: str) -> None:
        connection.execute(script_text)
        connection.commit()

    def execute_query(self, connection: psycopg.Connection[Any], query: str, *, read_only: bool = True) -> QueryResult:
        with connection.cursor() as cursor:
            if read_only:
                cursor.execute("SET TRANSACTION READ ONLY")
            cursor.execute(query)
            while cursor.description is None and cursor.nextset():
                pass
            if cursor.description is None:
                raise ValueError("Answers must return a result set.")
            columns = tuple(col.name for col in cursor.description)
            rows = [tuple(row) for row in cursor.fetchall()]
            return QueryResult(columns, rows)

    @contextmanager
    def grading_transaction(self, connection: psycopg.Connection[Any]) -> Iterator[psycopg.Connection[Any]]:
        with connection.transaction(force_rollback=True):
            yield connection
