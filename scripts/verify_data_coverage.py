"""Verify that deterministic seed data makes every official solution meaningful."""
from __future__ import annotations

import argparse
import os
from pathlib import Path

try:
    import psycopg
except ModuleNotFoundError:
    psycopg = None


ROOT = Path(__file__).resolve().parents[1]
DEFAULT_DSN = "postgresql://postgres@localhost:5432/sql_practice"
OUTER_JOIN_CONTRASTS = {
    "Q047": "review_count",
    "Q048": "active_product_count",
    "Q049": "total_units_on_hand",
    "Q050": "open_return_count",
}


def sql_without_terminator(path: Path) -> str:
    return path.read_text(encoding="utf-8").strip().rstrip(";")


def row_count(connection: psycopg.Connection[object], query: str) -> int:
    with connection.cursor() as cursor:
        cursor.execute(f"SELECT COUNT(*) FROM ({query}) AS coverage_result")
        return cursor.fetchone()[0]


def contrast_counts(connection: psycopg.Connection[object], query: str, column: str) -> tuple[int, int]:
    with connection.cursor() as cursor:
        cursor.execute(
            f"""
            SELECT COUNT(*) FILTER (WHERE coverage_result.{column} = 0),
                   COUNT(*) FILTER (WHERE coverage_result.{column} > 0)
            FROM ({query}) AS coverage_result
            """
        )
        return cursor.fetchone()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dsn",
        default=os.getenv("SQL_PRACTICE_DSN", DEFAULT_DSN),
        help="PostgreSQL connection string (defaults to SQL_PRACTICE_DSN or the local lab database).",
    )
    parser.add_argument(
        "--password",
        default=os.getenv("PGPASSWORD"),
        help="PostgreSQL password (defaults to PGPASSWORD).",
    )
    args = parser.parse_args()
    if psycopg is None:
        parser.error("psycopg is required; install dependencies with 'python -m pip install -r requirements.txt'.")
    solutions = sorted((ROOT / "solutions").glob("**/*.sql"))
    failures: list[str] = []

    with psycopg.connect(args.dsn, password=args.password) as connection:
        with connection.transaction():
            connection.execute("SET TRANSACTION READ ONLY")
            for path in solutions:
                exercise_id = path.stem.upper()
                query = sql_without_terminator(path)
                try:
                    with connection.transaction():
                        count = row_count(connection, query)
                        if count == 0:
                            failures.append(exercise_id)
                            print(f"{exercise_id}: FAIL (no rows)")
                            continue
                        print(f"{exercise_id}: PASS ({count} rows)")
                        if column := OUTER_JOIN_CONTRASTS.get(exercise_id):
                            zero_count, positive_count = contrast_counts(connection, query, column)
                            if zero_count == 0 or positive_count == 0:
                                failures.append(exercise_id)
                                print(f"  FAIL: expected both zero and positive {column} values; found {zero_count} zero and {positive_count} positive")
                            else:
                                print(f"  Contrast: {zero_count} zero and {positive_count} positive {column} values")
                except psycopg.Error as error:
                    failures.append(exercise_id)
                    print(f"{exercise_id}: FAIL ({error})")

    print(f"Summary: {len(solutions) - len(failures)}/{len(solutions)} solutions have meaningful results.")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
