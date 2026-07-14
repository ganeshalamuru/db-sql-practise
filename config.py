"""Central configuration for the SQL practice lab."""
from __future__ import annotations

import os
from dataclasses import dataclass


@dataclass(frozen=True)
class DatabaseConfig:
    dsn: str

    @classmethod
    def from_environment(cls) -> "DatabaseConfig":
        return cls(dsn=os.getenv("SQL_PRACTICE_DSN", "postgresql://postgres@localhost:5432/sql_practice"))


FLOAT_TOLERANCE = 1e-6
CATALOG_PATH = "exercise_catalog.json"
