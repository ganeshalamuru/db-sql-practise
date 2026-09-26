"""Base abstractions for multi-database support."""
from __future__ import annotations

from abc import ABC, abstractmethod
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Iterator


@dataclass(frozen=True)
class QueryResult:
    columns: tuple[str, ...]
    rows: list[tuple[Any, ...]]


class DatabaseAdapter(ABC):
    @property
    @abstractmethod
    def dialect_name(self) -> str:
        """Name of the SQL dialect/engine, e.g. 'sqlserver' or 'postgres'."""
        ...

    @property
    @abstractmethod
    def schema_filename(self) -> str:
        """Filename of the schema definition for this dialect."""
        ...

    @abstractmethod
    def connect(self, database: str | None = None, *, autocommit: bool = False) -> Any:
        """Return an active connection to the specified database."""
        ...

    @abstractmethod
    def database_exists(self, database: str) -> bool:
        """Return True if the database exists."""
        ...

    @abstractmethod
    def create_or_replace_database(self, database: str, recreate: bool) -> bool:
        """Drop (if recreate is True) and create the database. Return True if created."""
        ...

    @abstractmethod
    def schema_is_present(self, connection: Any) -> bool:
        """Return True if the core tables are present in the database."""
        ...

    @abstractmethod
    def seed_data_is_present(self, connection: Any) -> bool:
        """Return True if the seed data has already been populated."""
        ...

    @abstractmethod
    def execute_script(self, connection: Any, script_text: str) -> None:
        """Execute a multi-statement DDL or DML script."""
        ...

    @abstractmethod
    def execute_query(self, connection: Any, query: str, *, read_only: bool = True) -> QueryResult:
        """Execute a query and return its column names and rows."""
        ...

    @abstractmethod
    @contextmanager
    def grading_transaction(self, connection: Any) -> Iterator[Any]:
        """Context manager running an exercise inside a rollback transaction."""
        ...
