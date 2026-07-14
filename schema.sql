-- PostgreSQL 16+. Run this against a fresh database.

CREATE TABLE countries (
    country_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_code CHAR(2) NOT NULL UNIQUE,
    name TEXT NOT NULL UNIQUE
);

CREATE TABLE cities (
    city_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    country_id BIGINT NOT NULL REFERENCES countries,
    name TEXT NOT NULL,
    UNIQUE (country_id, name)
);

CREATE TABLE customers (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    city_id BIGINT REFERENCES cities,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    status TEXT NOT NULL CHECK (status IN ('active', 'suspended', 'closed'))
);

CREATE TABLE suppliers (
    supplier_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    contact_email TEXT NOT NULL UNIQUE,
    country_id BIGINT REFERENCES countries
);

CREATE TABLE categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    parent_category_id BIGINT REFERENCES categories,
    name TEXT NOT NULL,
    UNIQUE (parent_category_id, name)
);

CREATE TABLE products (
    product_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    supplier_id BIGINT NOT NULL REFERENCES suppliers,
    category_id BIGINT NOT NULL REFERENCES categories,
    sku TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE warehouses (
    warehouse_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_id BIGINT NOT NULL REFERENCES cities,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL UNIQUE,
    capacity_units INTEGER NOT NULL CHECK (capacity_units > 0)
);

CREATE TABLE inventory (
    warehouse_id BIGINT NOT NULL REFERENCES warehouses,
    product_id BIGINT NOT NULL REFERENCES products,
    quantity_on_hand INTEGER NOT NULL CHECK (quantity_on_hand >= 0),
    reorder_point INTEGER NOT NULL CHECK (reorder_point >= 0),
    PRIMARY KEY (warehouse_id, product_id)
);

CREATE TABLE employees (
    employee_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    warehouse_id BIGINT REFERENCES warehouses,
    manager_id BIGINT REFERENCES employees,
    email TEXT NOT NULL UNIQUE,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    hired_at DATE NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('associate', 'manager', 'analyst', 'buyer'))
);

CREATE TABLE promotions (
    promotion_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code TEXT NOT NULL UNIQUE,
    discount_percent NUMERIC(5, 2) NOT NULL,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    CHECK (discount_percent > 0 AND discount_percent <= 100),
    CHECK (ends_at > starts_at)
);

CREATE TABLE orders (
    order_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id BIGINT NOT NULL REFERENCES customers,
    promotion_id BIGINT REFERENCES promotions,
    ordered_at TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL CHECK (
        status IN ('pending', 'paid', 'shipped', 'delivered', 'cancelled')
    ),
    shipping_fee NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK (shipping_fee >= 0)
);

CREATE TABLE order_items (
    order_id BIGINT NOT NULL REFERENCES orders ON DELETE CASCADE,
    product_id BIGINT NOT NULL REFERENCES products,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, product_id)
);

CREATE TABLE payments (
    payment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE REFERENCES orders,
    payment_method TEXT NOT NULL CHECK (
        payment_method IN ('card', 'wallet', 'bank_transfer', 'cash_on_delivery')
    ),
    amount NUMERIC(12, 2) NOT NULL CHECK (amount >= 0),
    paid_at TIMESTAMPTZ,
    status TEXT NOT NULL CHECK (
        status IN ('pending', 'completed', 'failed', 'refunded')
    )
);

CREATE TABLE shipments (
    shipment_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL UNIQUE REFERENCES orders,
    warehouse_id BIGINT NOT NULL REFERENCES warehouses,
    tracking_number TEXT NOT NULL UNIQUE,
    shipped_at TIMESTAMPTZ,
    delivered_at TIMESTAMPTZ,
    status TEXT NOT NULL CHECK (
        status IN ('queued', 'shipped', 'delivered', 'returned')
    ),
    CHECK (
        delivered_at IS NULL
        OR shipped_at IS NULL
        OR delivered_at >= shipped_at
    )
);

CREATE TABLE reviews (
    review_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id BIGINT NOT NULL REFERENCES products,
    customer_id BIGINT NOT NULL REFERENCES customers,
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    body TEXT,
    created_at TIMESTAMPTZ NOT NULL,
    UNIQUE (product_id, customer_id)
);

CREATE TABLE returns (
    return_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id BIGINT NOT NULL REFERENCES orders,
    product_id BIGINT NOT NULL REFERENCES products,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    reason TEXT NOT NULL,
    requested_at TIMESTAMPTZ NOT NULL,
    status TEXT NOT NULL CHECK (
        status IN ('requested', 'approved', 'received', 'rejected')
    ),
    UNIQUE (order_id, product_id)
);

CREATE TABLE stores (
    store_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city_id BIGINT NOT NULL REFERENCES cities,
    code TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL UNIQUE,
    opened_at DATE NOT NULL
);

CREATE TABLE store_inventory (
    store_id BIGINT NOT NULL REFERENCES stores,
    product_id BIGINT NOT NULL REFERENCES products,
    quantity_on_hand INTEGER NOT NULL CHECK (quantity_on_hand >= 0),
    PRIMARY KEY (store_id, product_id)
);

CREATE INDEX idx_orders_customer_ordered
    ON orders (customer_id, ordered_at DESC);

CREATE INDEX idx_orders_status_ordered
    ON orders (status, ordered_at DESC);

CREATE INDEX idx_products_category
    ON products (category_id)
    WHERE is_active;

CREATE INDEX idx_reviews_product_created
    ON reviews (product_id, created_at DESC);

CREATE INDEX idx_inventory_low_stock
    ON inventory (warehouse_id)
    WHERE quantity_on_hand <= reorder_point;
