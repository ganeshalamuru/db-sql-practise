import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def test_catalog_ids_and_solutions_are_unique_and_present() -> None:
    catalog = json.loads((ROOT / "exercise_catalog.json").read_text())
    exercises = [exercise for module in catalog["modules"] for exercise in module["exercises"]]
    ids = [exercise["id"] for exercise in exercises]
    assert len(ids) == len(set(ids))
    for exercise in exercises:
        assert (ROOT / exercise["official_solution"]).is_file()
