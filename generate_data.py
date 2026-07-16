"""Deterministically generate PostgreSQL data without hand-authored INSERT lists."""
from __future__ import annotations

import argparse
import random
import sys
from datetime import UTC, date, datetime, timedelta
from decimal import Decimal
from pathlib import Path

SEED = 15445


def sql_text(value: object) -> str:
    if value is None:
        return "NULL"
    if isinstance(value, bool):
        return "TRUE" if value else "FALSE"
    if isinstance(value, str):
        return "'" + value.replace("'", "''") + "'"
    if isinstance(value, datetime):
        return "'" + value.isoformat(sep=" ") + "'"
    if isinstance(value, date):
        return "'" + value.isoformat() + "'"
    return str(value)


def emit(table: str, columns: tuple[str, ...], rows: list[tuple[object, ...]]) -> None:
    print(f"INSERT INTO {table} ({', '.join(columns)}) VALUES")
    print(",\n".join("(" + ", ".join(sql_text(value) for value in row) + ")" for row in rows) + ";")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--scale", choices=("dev", "full"), default="dev")
    parser.add_argument("--output", type=Path, default=Path("data.sql"))
    args = parser.parse_args()
    output_file = args.output.open("w", encoding="utf-8")
    sys.stdout = output_file
    counts = {"dev": (100, 100, 1_000, 5_000), "full": (5_000, 2_000, 50_000, 250_000)}[args.scale]
    customers, products, orders, target_items = counts
    employee_count = 50 if args.scale == "dev" else 500
    review_count = min(500 if args.scale == "dev" else 30_000, customers * products)
    rng = random.Random(SEED)
    now = datetime(2025, 1, 1, tzinfo=UTC)
    print("BEGIN;")
    emit("countries", ("country_code", "name"), [("IN", "India"), ("US", "United States"), ("DE", "Germany")])
    emit("cities", ("country_id", "name"), [(1, "Bengaluru"), (1, "Mumbai"), (2, "Austin"), (3, "Berlin")])
    emit("categories", ("parent_category_id", "name"), [
        (None, "Electronics"), (None, "Home"), (None, "Books"), (None, "Fitness"),
        (1, "Phones"), (1, "Laptops"), (2, "Kitchen"), (4, "Strength Training"),
    ])
    emit("suppliers", ("name", "contact_email", "country_id"), [(f"Supplier {i}", f"supplier{i}@example.test", 1 + i % 3) for i in range(1, 41)])
    emit("warehouses", ("city_id", "code", "name", "capacity_units"), [(1 + index % 4, f"WH-{index:02d}", f"Warehouse {index}", 70000 + index * 1000) for index in range(1, 11)])
    emit("customers", ("email", "first_name", "last_name", "city_id", "created_at", "status"), [(f"customer{i}@example.test", f"First{i}", f"Last{i}", 1 + i % 4, now - timedelta(days=i % 900), "active" if i % 20 else "suspended") for i in range(1, customers + 1)])
    emit("products", ("supplier_id", "category_id", "sku", "name", "unit_price", "is_active", "created_at"), [(1 + i % 40, 1 + i % 8, f"SKU-{i:06d}", f"Product {i}", Decimal(rng.randint(500, 200000)) / 100, i % 25 != 0, now - timedelta(days=i % 600)) for i in range(1, products + 1)])
    inventory = [(warehouse, product, rng.randint(0, 1000), rng.randint(10, 100)) for warehouse in range(1, 11) for product in range(1, products + 1)]
    emit("inventory", ("warehouse_id", "product_id", "quantity_on_hand", "reorder_point"), inventory)
    emit("employees", ("warehouse_id", "manager_id", "email", "first_name", "last_name", "hired_at", "role"), [(1 + employee_id % 10, None if employee_id <= 5 else employee_id // 5, f"employee{employee_id}@example.test", f"Employee{employee_id}", "Staff", now.date() - timedelta(days=employee_id * 12), "manager" if employee_id <= 5 or employee_id % 20 == 0 else "associate") for employee_id in range(1, employee_count + 1)])
    emit("stores", ("city_id", "code", "name", "opened_at"), [(1 + store_id % 4, f"STORE-{store_id:02d}", f"Store {store_id}", now.date() - timedelta(days=store_id * 300)) for store_id in range(1, 11)])
    order_rows = []
    payment_rows = []
    shipment_rows = []
    for order_id in range(1, orders + 1):
        status = ("delivered", "shipped", "paid", "cancelled")[order_id % 4]
        ordered = now - timedelta(days=order_id % 730, minutes=order_id % 1440)
        order_rows.append((1 + order_id % customers, None, ordered, status, Decimal(order_id % 1200) / 100))
        payment_rows.append((order_id, ("card", "wallet", "bank_transfer", "cash_on_delivery")[order_id % 4], Decimal(20 + order_id % 500), ordered, "completed" if status != "cancelled" else "refunded"))
        shipment_rows.append((order_id, 1 + order_id % 10, f"TRK{order_id:09d}", ordered + timedelta(days=1), ordered + timedelta(days=3) if status == "delivered" else None, "delivered" if status == "delivered" else "shipped"))
    emit("orders", ("customer_id", "promotion_id", "ordered_at", "status", "shipping_fee"), order_rows)
    items: list[tuple[object, ...]] = []
    for order_id in range(1, orders + 1):
        for offset in range(1, 1 + (target_items // orders)):
            product_id = ((order_id * 7 + offset) % products) + 1
            items.append((order_id, product_id, 1 + (offset % 3), Decimal(500 + product_id % 100000) / 100))
    emit("order_items", ("order_id", "product_id", "quantity", "unit_price"), items)
    emit("payments", ("order_id", "payment_method", "amount", "paid_at", "status"), payment_rows)
    emit("shipments", ("order_id", "warehouse_id", "tracking_number", "shipped_at", "delivered_at", "status"), shipment_rows)
    review_pairs: set[tuple[int, int]] = set()
    while len(review_pairs) < review_count:
        review_pairs.add((rng.randint(1, products), rng.randint(1, customers)))
    emit("reviews", ("product_id", "customer_id", "rating", "body", "created_at"), [(product_id, customer_id, rng.randint(1, 5), None if product_id % 7 == 0 else "Generated review", now - timedelta(days=rng.randint(1, 365))) for product_id, customer_id in sorted(review_pairs)])
    print("COMMIT;")
    output_file.close()


if __name__ == "__main__":
    main()
