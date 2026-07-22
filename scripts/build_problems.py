"""Render student-facing Markdown and a machine-readable exercise registry."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "exercise_catalog.json"


def render_problem(exercise: dict[str, object], answer_path: str) -> str:
    duplicate_rule = "Duplicates are significant." if exercise["duplicates_matter"] else "Duplicate rows are not significant."
    statement_type = str(exercise.get("statement_type", "SELECT"))
    if statement_type == "SELECT":
        instruction = f"Write one PostgreSQL `SELECT` statement in `{answer_path}`. Do not modify the schema or data."
    elif statement_type == "VIEW":
        instruction = (
            f"Write a PostgreSQL `CREATE OR REPLACE VIEW ... AS` statement followed by one `SELECT` statement in `{answer_path}`. "
            "The final SELECT must return the requested view result. The grader runs both statements in a transaction and rolls it back."
        )
    else:
        instruction = (
            f"Write one PostgreSQL `{statement_type}` statement in `{answer_path}`. "
            "Include a `RETURNING` clause with the requested columns. The grader runs the statement in a transaction and rolls it back."
        )
    return f"""# {exercise['id']} - {exercise['topic']}\n\n- **Difficulty:** {exercise['difficulty']} / 5\n- **Learning objective:** {exercise['learning_objective']}\n\n## Task\n\n{exercise['statement']}\n\n## Result requirements\n\n- **Ordering:** {exercise['ordering']}\n- **Duplicates:** {duplicate_rule}\n\n{instruction}\n"""


def main() -> None:
    catalog = json.loads(CATALOG.read_text(encoding="utf-8"))
    registry: dict[str, dict[str, object]] = {}
    for module in catalog["modules"]:
        exercise_dir = ROOT / "exercises" / module["slug"]
        exercise_dir.mkdir(parents=True, exist_ok=True)
        for exercise in module["exercises"]:
            filename = f"{str(exercise['id']).lower()}.md"
            answer_path = f"exercises/{module['slug']}/{str(exercise['id']).lower()}.sql"
            answer_file = ROOT / answer_path
            if not answer_file.exists():
                answer_file.write_text(
                    f"-- Task ({exercise['id']}): {exercise['statement']}\n"
                    f"-- Requirement: {exercise['ordering']}\n",
                    encoding="utf-8",
                )
            (exercise_dir / filename).write_text(render_problem(exercise, answer_path), encoding="utf-8")
            registry_entry = {
                "topic": exercise["topic"],
                "solution": exercise["official_solution"],
                "answer": answer_path,
                "ordering_required": exercise.get("ordering_required", True),
                "duplicates_matter": exercise["duplicates_matter"],
            }
            if exercise.get("statement_type", "SELECT") != "SELECT":
                registry_entry["statement_type"] = exercise["statement_type"]
            registry[str(exercise["id"])] = registry_entry
    (ROOT / "exercise_registry.json").write_text(json.dumps(registry, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
