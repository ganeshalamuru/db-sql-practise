# SQL answer-file convention

For every SQL answer file created or updated under `solutions/` or `exercises/`, begin the file with two SQL comments:

```sql
-- Task (Q###): <exercise task statement>
-- Requirement: <exercise ordering requirement>
```

Use the matching entry in `exercise_catalog.json` for the task statement and ordering requirement. Keep these comments current if the exercise changes, and place them before all SQL code.

# Local database testing

For local PostgreSQL testing, read the password at test time from
`C:\Users\ganes\Documents\db_password.txt` and use the `postgres` role. Do
not copy the password into the repository, environment files, commands shown
to the user, or documentation.
