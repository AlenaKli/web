CREATE TABLE IF NOT EXISTS customer_orders (
    id SERIAL PRIMARY KEY,
    customer_name TEXT NOT NULL,
    order_code TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO customer_orders (customer_name, order_code, notes, created_at)
SELECT 
    'Customer' || generate_series(1, 1000000),
    'ORDER-' || lpad(floor(random() * 1000000)::text, 6, '0'),
    'Note number ' || generate_series(1, 1000000) || ' with some additional text for testing search functionality',
    NOW() - (random() * interval '365 days')
FROM generate_series(1, 1000000);

EXPLAIN ANALYZE SELECT * FROM customer_orders WHERE order_code = 'ORDER-123456';

CREATE INDEX idx_order_code ON customer_orders(order_code);

EXPLAIN ANALYZE SELECT * FROM customer_orders WHERE order_code = 'ORDER-123456';

EXPLAIN ANALYZE SELECT * FROM customer_orders WHERE lower(notes) LIKE '%search functionality%';

CREATE INDEX idx_notes_lower ON customer_orders (lower(notes));

EXPLAIN ANALYZE SELECT * FROM customer_orders WHERE lower(notes) LIKE '%search functionality%';