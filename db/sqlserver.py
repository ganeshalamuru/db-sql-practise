"""Microsoft SQL Server database adapter using pyodbc."""
from __future__ import annotations

import logging
import re
from contextlib import contextmanager
from typing import Any, Iterator

import pyodbc

from db.base import DatabaseAdapter, QueryResult

LOGGER = logging.getLogger(__name__)

DEFAULT_SQLSERVER_CONN = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=sql_practice;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)


def split_sql_statements(sql: str) -> list[str]:
    """Split a SQL script into individual statements by semicolon outside quotes."""
    statements: list[str] = []
    current: list[str] = []
    in_single_quote = False
    in_line_comment = False

    i = 0
    chars = list(sql)
    n = len(chars)

    while i < n:
        char = chars[i]
        next_char = chars[i + 1] if i + 1 < n else ""

        if in_line_comment:
            if char == "\n":
                in_line_comment = False
            current.append(char)
        elif in_single_quote:
            if char == "'":
                if next_char == "'":
                    # Escaped quote
                    current.append(char)
                    current.append(next_char)
                    i += 1
                else:
                    in_single_quote = False
                    current.append(char)
            else:
                current.append(char)
        else:
            if char == "-" and next_char == "-":
                in_line_comment = True
                current.append(char)
                current.append(next_char)
                i += 1
            elif char == "'":
                in_single_quote = True
                current.append(char)
            elif char == ";":
                stmt = "".join(current).strip()
                if stmt:
                    statements.append(stmt)
                current = []
            else:
                current.append(char)
        i += 1

    last = "".join(current).strip()
    if last:
        statements.append(last)
    return statements


class SqlServerAdapter(DatabaseAdapter):
    def __init__(self, conn_str: str | None = None, password: str | None = None):
        self._conn_str = conn_str or DEFAULT_SQLSERVER_CONN
        if password and "PWD=" not in self._conn_str.upper():
            self._conn_str = self._conn_str.rstrip(";") + f";PWD={password};"

    @property
    def dialect_name(self) -> str:
        return "sqlserver"

    @property
    def schema_filename(self) -> str:
        return "schema.sqlserver.sql"

    def _conn_str_for(self, database: str | None) -> str:
        if not database:
            return self._conn_str
        if re.search(r"DATABASE=[^;]*", self._conn_str, re.IGNORECASE):
            return re.sub(
                r"DATABASE=[^;]*",
                f"DATABASE={database}",
                self._conn_str,
                flags=re.IGNORECASE,
            )
        return self._conn_str.rstrip(";") + f";DATABASE={database};"

    def connect(self, database: str | None = None, *, autocommit: bool = True) -> pyodbc.Connection:
        conn_str = self._conn_str_for(database)
        connection = pyodbc.connect(conn_str, autocommit=autocommit)
        return connection

    def database_exists(self, database: str) -> bool:
        with self.connect("master", autocommit=True) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1 FROM sys.databases WHERE name = ?", (database,))
                return cursor.fetchone() is not None

    def create_or_replace_database(self, database: str, recreate: bool) -> bool:
        with self.connect("master", autocommit=True) as conn:
            with conn.cursor() as cursor:
                cursor.execute("SELECT 1 FROM sys.databases WHERE name = ?", (database,))
                exists = cursor.fetchone() is not None
                if exists and recreate:
                    cursor.execute(
                        f"ALTER DATABASE [{database}] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;\n"
                        f"DROP DATABASE [{database}];"
                    )
                    exists = False
                if not exists:
                    cursor.execute(f"CREATE DATABASE [{database}];")
                    return True
        return False

    def schema_is_present(self, connection: pyodbc.Connection) -> bool:
        with connection.cursor() as cursor:
            cursor.execute("SELECT 1 FROM sys.tables WHERE name = 'countries'")
            return cursor.fetchone() is not None

    def seed_data_is_present(self, connection: pyodbc.Connection) -> bool:
        with connection.cursor() as cursor:
            cursor.execute("SELECT CASE WHEN EXISTS (SELECT 1 FROM countries) THEN 1 ELSE 0 END")
            result = cursor.fetchone()
            return bool(result and result[0] == 1)

    def execute_script(self, connection: pyodbc.Connection, script_text: str) -> None:
        with connection.cursor() as cursor:
            cleaned_script = "\n".join(
                line for line in script_text.splitlines() if line.strip().upper() != "GO"
            )
            cursor.execute(cleaned_script)

    def execute_query(self, connection: pyodbc.Connection, query: str, *, read_only: bool = True) -> QueryResult:
        statements = split_sql_statements(query)
        if not statements:
            raise ValueError("Answers must return a result set.")

        with connection.cursor() as cursor:
            columns: tuple[str, ...] | None = None
            rows: list[tuple[Any, ...]] | None = None

            for stmt in statements:
                non_comment_lines = [
                    l for l in stmt.splitlines() if not l.strip().startswith("--")
                ]
                if not "".join(non_comment_lines).strip():
                    continue

                cursor.execute(stmt)
                while cursor.description is None and cursor.nextset():
                    pass
                if cursor.description is not None:
                    columns = tuple(col[0] for col in cursor.description)
                    rows = [tuple(row) for row in cursor.fetchall()]

            if columns is None or rows is None:
                raise ValueError("Answers must return a result set.")

            return QueryResult(columns, rows)

    @contextmanager
    def grading_transaction(self, connection: pyodbc.Connection) -> Iterator[pyodbc.Connection]:
        with connection.cursor() as cursor:
            cursor.execute("BEGIN TRANSACTION")
        try:
            yield connection
        finally:
            with connection.cursor() as cursor:
                cursor.execute("IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION")
