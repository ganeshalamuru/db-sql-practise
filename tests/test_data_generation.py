import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def insert_block(sql: str, table: str) -> str:
    marker = f"INSERT INTO {table} "
    start = sql.index(marker)
    end = sql.index(";", start)
    return sql[start:end]


def test_dev_seed_emits_all_tables_and_teaching_contrasts(tmp_path: Path) -> None:
    output = tmp_path / "data.sql"
    subprocess.run(
        [sys.executable, str(ROOT / "generate_data.py"), "--scale", "dev", "--output", str(output)],
        check=True,
        cwd=ROOT,
    )
    sql = output.read_text(encoding="utf-8")

    for table in (
        "countries", "cities", "categories", "suppliers", "warehouses",
        "customers", "products", "inventory", "employees", "stores",
        "promotions", "orders", "order_items", "payments", "shipments",
        "returns", "store_inventory", "reviews",
    ):
        assert f"INSERT INTO {table} " in sql

    inventory = insert_block(sql, "inventory")
    assert "(10," not in inventory  # Q049 has a warehouse with no rows.

    returns = insert_block(sql, "returns")
    for status in ("requested", "approved", "received", "rejected"):
        assert f"'{status}'" in returns

    store_inventory = insert_block(sql, "store_inventory")
    assert ", 11," not in store_inventory  # Product 11 is low stock but unavailable in stores for Q070.

    reviews = insert_block(sql, "reviews")
    assert "(17, 1, 5," in reviews  # Q040 has a guaranteed high-rated product.
