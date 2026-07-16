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
    customer_rows = []
    for customer_id in range(1, customers + 1):
        status = "closed" if customer_id % 31 == 0 else "suspended" if customer_id % 20 == 0 else "active"
        customer_rows.append((f"customer{customer_id}@example.test", f"First{customer_id}", f"Last{customer_id}", 1 + customer_id % 4, now - timedelta(days=customer_id % 900), status))
    emit("customers", ("email", "first_name", "last_name", "city_id", "created_at", "status"), customer_rows)

    product_rows = []
    product_prices: dict[int, Decimal] = {}
    for product_id in range(1, products + 1):
        # Supplier 1 has enough active products for the HAVING exercises;
        # supplier 40 has only inactive products, providing an outer-join zero.
        supplier_id = 40 if product_id % 25 == 0 else 1 if product_id % 8 == 0 else 1 + product_id % 39
        unit_price = Decimal(rng.randint(500, 200000)) / 100
        product_prices[product_id] = unit_price
        product_rows.append((supplier_id, 1 + product_id % 8, f"SKU-{product_id:06d}", f"Product {product_id}", unit_price, product_id % 25 != 0, now - timedelta(days=product_id % 600)))
    emit("products", ("supplier_id", "category_id", "sku", "name", "unit_price", "is_active", "created_at"), product_rows)

    # Warehouse 10 intentionally has no inventory rows.  Products divisible by
    # 11 are deliberately low stock and are unavailable in every store below.
    inventory = []
    for warehouse_id in range(1, 10):
        for product_id in range(1, products + 1):
            if product_id % 11 == 0:
                inventory.append((warehouse_id, product_id, rng.randint(0, 15), rng.randint(40, 100)))
            else:
                inventory.append((warehouse_id, product_id, rng.randint(600, 1000), rng.randint(50, 200)))
    emit("inventory", ("warehouse_id", "product_id", "quantity_on_hand", "reorder_point"), inventory)
    emit("employees", ("warehouse_id", "manager_id", "email", "first_name", "last_name", "hired_at", "role"), [(1 + employee_id % 10, None if employee_id <= 5 else employee_id // 5, f"employee{employee_id}@example.test", f"Employee{employee_id}", "Staff", now.date() - timedelta(days=employee_id * 12), "manager" if employee_id <= 5 or employee_id % 20 == 0 else "associate") for employee_id in range(1, employee_count + 1)])
    emit("stores", ("city_id", "code", "name", "opened_at"), [(1 + store_id % 4, f"STORE-{store_id:02d}", f"Store {store_id}", now.date() - timedelta(days=store_id * 300)) for store_id in range(1, 11)])
    emit("promotions", ("code", "discount_percent", "starts_at", "ends_at"), [(f"PROMO-{promotion_id:02d}", Decimal(5 * promotion_id), now - timedelta(days=90 * promotion_id), now + timedelta(days=30 * promotion_id)) for promotion_id in range(1, 6)])

    order_rows = []
    payment_rows = []
    shipment_rows = []
    ordered_customer_count = customers - max(5, customers // 10)
    for order_id in range(1, orders + 1):
        status = ("pending", "paid", "shipped", "delivered", "cancelled")[order_id % 5]
        ordered = now - timedelta(days=order_id % 730, minutes=order_id % 1440)
        order_rows.append((1 + order_id % ordered_customer_count, 1 + order_id % 5 if order_id % 11 == 0 else None, ordered, status, Decimal(order_id % 1200) / 100))
        payment_status = "refunded" if status == "cancelled" else "failed" if order_id % 17 == 0 else "pending" if order_id % 19 == 0 else "completed"
        payment_rows.append((order_id, ("card", "wallet", "bank_transfer", "cash_on_delivery")[order_id % 4], Decimal(20 + order_id % 500), ordered, payment_status))
        shipment_status = "delivered" if status == "delivered" else "returned" if status == "cancelled" else "queued" if status == "pending" else "shipped"
        shipment_rows.append((order_id, 1 + order_id % 10, f"TRK{order_id:09d}", ordered + timedelta(days=1), ordered + timedelta(days=3) if shipment_status == "delivered" else None, shipment_status))
    emit("orders", ("customer_id", "promotion_id", "ordered_at", "status", "shipping_fee"), order_rows)
    items: list[tuple[object, ...]] = []
    items_by_order: dict[int, list[tuple[int, int]]] = {}
    for order_id in range(1, orders + 1):
        for offset in range(1, 1 + (target_items // orders)):
            product_id = ((order_id * 7 + offset) % products) + 1
            # Some orders contain only quantities of at least two; others do
            # not, so ALL can distinguish both cases.
            quantity = 2 + offset % 2 if order_id % 6 == 0 else 1 + offset % 3
            items.append((order_id, product_id, quantity, product_prices[product_id]))
            items_by_order.setdefault(order_id, []).append((product_id, quantity))
    emit("order_items", ("order_id", "product_id", "quantity", "unit_price"), items)
    emit("payments", ("order_id", "payment_method", "amount", "paid_at", "status"), payment_rows)
    emit("shipments", ("order_id", "warehouse_id", "tracking_number", "shipped_at", "delivered_at", "status"), shipment_rows)
    returns = []
    for return_number, order_id in enumerate(range(8, orders + 1, 8)):
        product_id, quantity = items_by_order[order_id][0]
        returns.append((order_id, product_id, quantity, "Generated return", now - timedelta(days=order_id % 365), ("requested", "approved", "received", "rejected")[return_number % 4]))
    emit("returns", ("order_id", "product_id", "quantity", "reason", "requested_at", "status"), returns)

    store_inventory = []
    for store_id in range(1, 11):
        for product_id in range(1, products + 1):
            if product_id % 11 != 0 and product_id % 3 == store_id % 3:
                store_inventory.append((store_id, product_id, 0 if product_id % 13 == 0 else rng.randint(10, 500)))
    emit("store_inventory", ("store_id", "product_id", "quantity_on_hand"), store_inventory)

    # Reserve a handful of active products without reviews and guarantee a
    # high-rated, sufficiently reviewed product for GROUP BY/HAVING practice.
    review_pairs: set[tuple[int, int]] = {(7, 1)} | {(17, customer_id) for customer_id in range(1, 7)}
    while len(review_pairs) < review_count:
        review_pairs.add((rng.randint(1, products - 5), rng.randint(1, customers)))
    emit("reviews", ("product_id", "customer_id", "rating", "body", "created_at"), [(product_id, customer_id, 5 if product_id == 17 else rng.randint(1, 5), None if product_id % 7 == 0 else "Generated review", now - timedelta(days=rng.randint(1, 365))) for product_id, customer_id in sorted(review_pairs)])
    print("COMMIT;")
    output_file.close()


if __name__ == "__main__":
    main()
