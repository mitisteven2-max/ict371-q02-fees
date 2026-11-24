-- ICT371 Q2 (f): composite index (equality column first, range column second)
CREATE INDEX IF NOT EXISTS idx_payments_student_paid_on
    ON payments (student_id, paid_on);

ANALYZE payments;
SET enable_seqscan = off;   -- tiny table: force the planner to show the index

EXPLAIN
SELECT payment_id, amount, paid_on
FROM payments
WHERE student_id = 1
  AND paid_on BETWEEN DATE '2026-11-01' AND DATE '2026-11-30';

RESET enable_seqscan;
