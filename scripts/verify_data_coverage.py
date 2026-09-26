"""Verify that deterministic seed data makes every official solution meaningful."""
from __future__ import annotations

import argparse
import json
import os
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from config import DatabaseConfig
from db import DatabaseAdapter, QueryResult, get_adapter

OUTER_JOIN_CONTRASTS = {
    "Q047": "review_count",
    "Q048": "active_product_count",
    "Q049": "total_units_on_hand",
    "Q050": "open_return_count",
}


def main() -> int:
    config = DatabaseConfig.from_environment()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dialect",
        choices=("sqlserver", "postgres"),
        default=config.dialect,
        help="Database engine dialect (defaults to SQL_PRACTICE_DIALECT or sqlserver).",
    )
    parser.add_argument(
        "--dsn",
        default=None,
        help="Database connection string (defaults to SQL_PRACTICE_DSN).",
    )
    parser.add_argument(
        "--password",
        default=config.password,
        help="Database password (defaults to PGPASSWORD / SQL_PASSWORD).",
    )
    args = parser.parse_args()
    adapter = get_adapter(args.dialect, args.dsn, args.password)
    catalog = json.loads((ROOT / "exercise_catalog.json").read_text(encoding="utf-8"))
    select_solution_paths = {
        exercise["official_solution"]
        for module in catalog["modules"]
        for exercise in module["exercises"]
        if exercise.get("statement_type", "SELECT") == "SELECT"
    }
    solutions = sorted(ROOT / path for path in select_solution_paths)
    failures: list[str] = []

    with adapter.connect("sql_practice") as connection:
        for path in solutions:
            exercise_id = path.stem.upper()
            if not path.exists():
                failures.append(exercise_id)
                print(f"{exercise_id}: FAIL (file not found)")
                continue
            query = path.read_text(encoding="utf-8")
            try:
                with adapter.grading_transaction(connection):
                    res = adapter.execute_query(connection, query, read_only=True)
                    count = len(res.rows)
                    if count == 0:
                        failures.append(exercise_id)
                        print(f"{exercise_id}: FAIL (no rows)")
                        continue
                    print(f"{exercise_id}: PASS ({count} rows)")
                    if column := OUTER_JOIN_CONTRASTS.get(exercise_id):
                        if column not in res.columns:
                            failures.append(exercise_id)
                            print(f"  FAIL: column '{column}' not found in result columns {res.columns}")
                            continue
                        col_idx = res.columns.index(column)
                        zero_count = sum(1 for row in res.rows if row[col_idx] == 0)
                        positive_count = sum(1 for row in res.rows if row[col_idx] is not None and row[col_idx] > 0)
                        if zero_count == 0 or positive_count == 0:
                            failures.append(exercise_id)
                            print(f"  FAIL: expected both zero and positive {column} values; found {zero_count} zero and {positive_count} positive")
                        else:
                            print(f"  Contrast: {zero_count} zero and {positive_count} positive {column} values")
            except Exception as error:
                failures.append(exercise_id)
                print(f"{exercise_id}: FAIL ({error})")

    print(f"Summary: {len(solutions) - len(failures)}/{len(solutions)} solutions have meaningful results.")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
