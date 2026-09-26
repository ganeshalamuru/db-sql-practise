"""Execute and compare SQL practice answers without comparing query text."""
from __future__ import annotations

import argparse
import json
import logging
import math
import os
from decimal import Decimal
from pathlib import Path
from typing import Any

from config import DatabaseConfig, FLOAT_TOLERANCE
from db import DatabaseAdapter, QueryResult, get_adapter

ROOT = Path(__file__).resolve().parent
LOGGER = logging.getLogger(__name__)


def numeric_equal(left: Any, right: Any) -> bool:
    if isinstance(left, (float, Decimal)) or isinstance(right, (float, Decimal)):
        try:
            return math.isclose(float(left), float(right), abs_tol=FLOAT_TOLERANCE, rel_tol=FLOAT_TOLERANCE)
        except (TypeError, ValueError):
            return False
    return left == right


def rows_equal(left: tuple[Any, ...], right: tuple[Any, ...]) -> bool:
    return len(left) == len(right) and all(numeric_equal(a, b) for a, b in zip(left, right, strict=True))


def unordered_equal(expected: list[tuple[Any, ...]], actual: list[tuple[Any, ...]]) -> bool:
    remaining = list(actual)
    for expected_row in expected:
        for index, actual_row in enumerate(remaining):
            if rows_equal(expected_row, actual_row):
                remaining.pop(index)
                break
        else:
            return False
    return not remaining


def unique_rows(rows: list[tuple[Any, ...]]) -> list[tuple[Any, ...]]:
    """Deduplicate using the same NULL and numeric semantics as grading."""
    unique: list[tuple[Any, ...]] = []
    for row in rows:
        if not any(rows_equal(row, existing) for existing in unique):
            unique.append(row)
    return unique


def results_equal(expected: QueryResult, actual: QueryResult, spec: dict[str, Any]) -> bool:
    if expected.columns != actual.columns:
        return False
    expected_rows, actual_rows = expected.rows, actual.rows
    if not spec["duplicates_matter"]:
        expected_rows, actual_rows = unique_rows(expected_rows), unique_rows(actual_rows)
    if spec["ordering_required"]:
        return len(expected_rows) == len(actual_rows) and all(
            rows_equal(left, right)
            for left, right in zip(expected_rows, actual_rows, strict=True)
        )
    return unordered_equal(expected_rows, actual_rows)


def resolve_solution_path(spec: dict[str, Any], dialect: str) -> Path:
    original_rel = Path(spec["solution"])
    if dialect in ("sqlserver", "mssql"):
        dialect_path = ROOT / original_rel.with_suffix(".sqlserver.sql")
        if dialect_path.exists():
            return dialect_path
    return ROOT / original_rel


def resolve_answer_path(spec: dict[str, Any], dialect: str) -> Path:
    original_rel = Path(spec["answer"])
    if dialect in ("sqlserver", "mssql"):
        dialect_path = ROOT / original_rel.with_suffix(".sqlserver.sql")
        if dialect_path.exists():
            return dialect_path
    return ROOT / original_rel


def grade_one(adapter: DatabaseAdapter, connection: Any, exercise_id: str, spec: dict[str, Any]) -> bool:
    solution_path = resolve_solution_path(spec, adapter.dialect_name)
    answer_path = resolve_answer_path(spec, adapter.dialect_name)
    if not answer_path.exists():
        print(f"{exercise_id}: FAIL — missing {answer_path.relative_to(ROOT)}")
        return False
    try:
        statement_type = spec.get("statement_type", "SELECT")
        if statement_type not in {"SELECT", "INSERT", "UPDATE", "DELETE", "VIEW", "CONSTRAINT", "TRANSACTION"}:
            raise ValueError(f"Unsupported statement type: {statement_type}")
        with adapter.grading_transaction(connection):
            expected = adapter.execute_query(
                connection,
                solution_path.read_text(encoding="utf-8"),
                read_only=statement_type == "SELECT",
            )
        with adapter.grading_transaction(connection):
            actual = adapter.execute_query(
                connection,
                answer_path.read_text(encoding="utf-8"),
                read_only=statement_type == "SELECT",
            )
    except Exception as error:
        print(f"{exercise_id}: FAIL — {error}")
        return False
    if expected.columns != actual.columns:
        print(f"{exercise_id}: FAIL — expected columns {expected.columns}; got {actual.columns}")
        return False
    if results_equal(expected, actual, spec):
        print(f"{exercise_id}: PASS ({len(actual.rows)} rows)")
        return True
    print(f"{exercise_id}: FAIL — expected {len(expected.rows)} rows; got {len(actual.rows)} rows")
    print(f"  Expected sample: {expected.rows[:3]}\n  Actual sample:   {actual.rows[:3]}")
    return False


def main() -> int:
    config = DatabaseConfig.from_environment()
    parser = argparse.ArgumentParser(description="Grade SQL practice exercises.")
    parser.add_argument("--problem")
    parser.add_argument("--topic")
    parser.add_argument(
        "--dialect",
        choices=("sqlserver", "postgres"),
        default=config.dialect,
        help="Database engine dialect (defaults to SQL_PRACTICE_DIALECT or sqlserver).",
    )
    parser.add_argument("--dsn", default=None, help="Custom connection string or DSN.")
    parser.add_argument(
        "--password",
        default=config.password,
        help="Database password (defaults to PGPASSWORD / SQL_PASSWORD).",
    )
    args = parser.parse_args()
    adapter = get_adapter(args.dialect, args.dsn, args.password)
    registry = json.loads((ROOT / "exercise_registry.json").read_text(encoding="utf-8"))
    selected = {
        key: value
        for key, value in registry.items()
        if (not args.problem or key == args.problem.upper())
        and (not args.topic or value["topic"].lower() == args.topic.lower())
    }
    if not selected:
        parser.error("No matching exercises. Run scripts/build_problems.py first.")
    with adapter.connect("sql_practice") as connection:
        passed = sum(grade_one(adapter, connection, key, spec) for key, spec in selected.items())
    print(f"Summary: {passed}/{len(selected)} passed ({passed / len(selected):.0%})")
    return 0 if passed == len(selected) else 1


if __name__ == "__main__":
    raise SystemExit(main())
