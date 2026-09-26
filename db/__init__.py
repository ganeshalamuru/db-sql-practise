"""Database abstraction package."""
from __future__ import annotations

import os

from db.base import DatabaseAdapter, QueryResult
from db.postgres import PostgresAdapter
from db.sqlserver import SqlServerAdapter

__all__ = ["DatabaseAdapter", "QueryResult", "get_adapter", "PostgresAdapter", "SqlServerAdapter"]


def get_adapter(
    dialect: str | None = None,
    dsn: str | None = None,
    password: str | None = None,
) -> DatabaseAdapter:
    """Return the configured DatabaseAdapter instance."""
    resolved_dialect = (
        dialect
        or os.getenv("SQL_PRACTICE_DIALECT")
        or ("postgres" if dsn and dsn.startswith("postgresql://") else "sqlserver")
    ).lower()

    if resolved_dialect in ("sqlserver", "mssql"):
        return SqlServerAdapter(conn_str=dsn, password=password)
    elif resolved_dialect in ("postgres", "postgresql"):
        return PostgresAdapter(dsn=dsn, password=password)
    else:
        raise ValueError(
            f"Unsupported database dialect '{resolved_dialect}'. Supported dialects: 'sqlserver', 'postgres'."
        )
