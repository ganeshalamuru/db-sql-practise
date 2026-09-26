"""Central configuration for the SQL practice lab."""
from __future__ import annotations

import os
from dataclasses import dataclass

from db import DatabaseAdapter, get_adapter

DEFAULT_SQLSERVER_DSN = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=localhost;"
    "DATABASE=sql_practice;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)
DEFAULT_POSTGRES_DSN = "postgresql://postgres@localhost:5432/sql_practice"


@dataclass(frozen=True)
class DatabaseConfig:
    dialect: str
    dsn: str
    password: str | None = None

    @classmethod
    def from_environment(
        cls,
        dialect: str | None = None,
        dsn: str | None = None,
        password: str | None = None,
    ) -> "DatabaseConfig":
        env_dialect = dialect or os.getenv("SQL_PRACTICE_DIALECT")
        if not env_dialect:
            env_dsn = dsn or os.getenv("SQL_PRACTICE_DSN")
            if env_dsn and env_dsn.startswith("postgresql://"):
                env_dialect = "postgres"
            else:
                env_dialect = "sqlserver"
        resolved_dialect = env_dialect.lower()

        resolved_dsn = dsn or os.getenv("SQL_PRACTICE_DSN")
        if not resolved_dsn:
            resolved_dsn = (
                DEFAULT_SQLSERVER_DSN
                if resolved_dialect in ("sqlserver", "mssql")
                else DEFAULT_POSTGRES_DSN
            )

        resolved_password = (
            password
            or os.getenv("SQL_PASSWORD")
            or os.getenv("PGPASSWORD")
        )

        return cls(dialect=resolved_dialect, dsn=resolved_dsn, password=resolved_password)

    def get_adapter(self) -> DatabaseAdapter:
        return get_adapter(self.dialect, self.dsn, self.password)


FLOAT_TOLERANCE = 1e-6
CATALOG_PATH = "exercise_catalog.json"
