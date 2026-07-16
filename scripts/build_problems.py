"""Render student-facing Markdown and a machine-readable exercise registry."""
from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CATALOG = ROOT / "exercise_catalog.json"


def render_problem(exercise: dict[str, object], answer_path: str) -> str:
    duplicate_rule = "Duplicates are significant." if exercise["duplicates_matter"] else "Duplicate rows are not significant."
    return f"""# {exercise['id']} - {exercise['topic']}\n\n- **Difficulty:** {exercise['difficulty']} / 5\n- **Learning objective:** {exercise['learning_objective']}\n\n## Task\n\n{exercise['statement']}\n\n## Result requirements\n\n- **Ordering:** {exercise['ordering']}\n- **Duplicates:** {duplicate_rule}\n\nWrite one PostgreSQL `SELECT` statement in `{answer_path}`. Do not modify the schema or data.\n"""


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
                answer_file.touch()
            (exercise_dir / filename).write_text(render_problem(exercise, answer_path), encoding="utf-8")
            registry[str(exercise["id"])] = {
                "topic": exercise["topic"],
                "solution": exercise["official_solution"],
                "answer": answer_path,
                "ordering_required": True,
                "duplicates_matter": exercise["duplicates_matter"],
            }
    (ROOT / "exercise_registry.json").write_text(json.dumps(registry, indent=2) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
