# Architecture

The exercise catalog is the source of truth. `scripts/build_problems.py` converts its structured metadata into student-facing Markdown and `exercise_registry.json`, which the grader consumes. It also creates any missing blank answer files beside their prompts in `exercises/<topic>/`, but never overwrites an existing answer. Instructor-only solutions remain organized by matching topic folders in `solutions/`. Adding an exercise means adding one catalog object, one instructor-only solution, and rerunning the build script.

The PostgreSQL schema models a multi-warehouse retailer. Data is generated deterministically from `generate_data.py`; the default development scale is intentionally modest, while `--scale full` produces the lab-sized dataset.

`grader.py` executes each answer and its official solution in read-only transactions, then compares column names, rows, duplicate multiplicity, ordering when required, NULLs, and numeric values using a small tolerance.
