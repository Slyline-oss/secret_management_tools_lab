CREATE TABLE IF NOT EXISTS demo_record (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

INSERT INTO demo_record(name) VALUES ('initial-record')
ON CONFLICT DO NOTHING;