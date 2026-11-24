-- ICT371 Q2 (a): tables, constraints, students
DROP TABLE IF EXISTS daily_collections, payment_audit, payments, students CASCADE;

CREATE TABLE students (
    student_id      SERIAL PRIMARY KEY,
    student_number  VARCHAR(20)   NOT NULL UNIQUE,
    full_name       VARCHAR(100)  NOT NULL,
    fee_due         NUMERIC(12,2) NOT NULL CHECK (fee_due >= 0)
);

CREATE TABLE payments (
    payment_id  SERIAL PRIMARY KEY,
    student_id  INTEGER       NOT NULL REFERENCES students(student_id),
    amount      NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    paid_on     DATE          NOT NULL
);

CREATE TABLE payment_audit (
    audit_id    SERIAL PRIMARY KEY,
    payment_id  INTEGER       NOT NULL REFERENCES payments(payment_id),
    student_id  INTEGER       NOT NULL REFERENCES students(student_id),
    amount      NUMERIC(12,2) NOT NULL,
    logged_at   TIMESTAMP     NOT NULL DEFAULT now()
);

CREATE TABLE daily_collections (
    collection_date  DATE PRIMARY KEY,
    payment_count    INTEGER       NOT NULL CHECK (payment_count >= 0),
    total_amount     NUMERIC(14,2) NOT NULL CHECK (total_amount >= 0)
);

-- Three students with different fee positions (payments are loaded in 08)
INSERT INTO students (student_number, full_name, fee_due) VALUES
    ('202401001', 'Chileshe Banda', 5000.00),
    ('202401002', 'Mutale Phiri',   3000.00),
    ('202401003', 'Natasha Zulu',   4000.00);
