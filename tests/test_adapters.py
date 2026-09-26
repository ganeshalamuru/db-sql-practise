import pytest
from db import get_adapter
from db.sqlserver import SqlServerAdapter, split_sql_statements
from db.postgres import PostgresAdapter


def test_get_adapter_factory() -> None:
    sqlserver = get_adapter("sqlserver")
    assert isinstance(sqlserver, SqlServerAdapter)
    assert sqlserver.dialect_name == "sqlserver"
    assert sqlserver.schema_filename == "schema.sqlserver.sql"

    postgres = get_adapter("postgres")
    assert isinstance(postgres, PostgresAdapter)
    assert postgres.dialect_name == "postgres"
    assert postgres.schema_filename == "schema.sql"

    with pytest.raises(ValueError, match="Unsupported database dialect"):
        get_adapter("sqlite")


def test_sqlserver_statement_splitter() -> None:
    script = """
    -- Comment with semicolon;
    CREATE OR ALTER VIEW active_cust AS
    SELECT customer_id, email FROM customers WHERE status = 'active';

    SELECT * FROM active_cust;
    """
    stmts = split_sql_statements(script)
    assert len(stmts) == 2
    assert "CREATE OR ALTER VIEW active_cust AS" in stmts[0]
    assert stmts[1].startswith("SELECT * FROM active_cust")


def test_sqlserver_live_query_execution() -> None:
    adapter = get_adapter("sqlserver")
    try:
        conn = adapter.connect("sql_practice")
    except Exception:
        pytest.skip("Local SQL Server sql_practice database not available.")

    with adapter.grading_transaction(conn):
        res = adapter.execute_query(conn, "SELECT 1 AS num, 'hello' AS greeting")
        assert res.columns == ("num", "greeting")
        assert res.rows == [(1, "hello")]
