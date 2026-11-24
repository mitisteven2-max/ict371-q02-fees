-- (b) balances: 2000, 0, 4000 (no payments -> full fee)
SELECT student_id, fn_fee_balance(student_id) AS balance FROM students ORDER BY 1;
DO $$ BEGIN PERFORM fn_fee_balance(999);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (c) rejections
DO $$ BEGIN CALL pr_receive_payment(3, NULL, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN CALL pr_receive_payment(3, 0, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN CALL pr_receive_payment(3, -50, CURRENT_DATE);
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;
DO $$ BEGIN CALL pr_receive_payment(3, 4500, CURRENT_DATE);   -- above balance
EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Rejected: %', SQLERRM; END $$;

-- (c)+(d) valid payment: fee_due unchanged, audit row written by the trigger
CALL pr_receive_payment(3, 1000, CURRENT_DATE);
SELECT student_id, fee_due FROM students WHERE student_id = 3;   -- still 4000
SELECT * FROM payment_audit ORDER BY audit_id;                   -- 7 rows

-- (e) Mutale (settled) must not appear
SELECT * FROM v_fee_balances ORDER BY student_number;

-- (g) run twice: no double counting
CALL pr_refresh_collections(DATE '2026-11-10');
CALL pr_refresh_collections(DATE '2026-11-10');
SELECT * FROM daily_collections ORDER BY collection_date;

-- (f) EXPLAIN again now that the tables contain data
ANALYZE payments;
SET enable_seqscan = off;   -- tiny table: force the planner to show the index

EXPLAIN
SELECT payment_id, amount, paid_on
FROM payments
WHERE student_id = 1
  AND paid_on BETWEEN DATE '2026-11-01' AND DATE '2026-11-30';

RESET enable_seqscan;
