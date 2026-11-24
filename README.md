# ICT371 Q2 - University Fee Payments

**Student:** Steven Miti (202405283)  
**DBMS:** PostgreSQL 13+ with the pg_cron extension

## How to run
Use a fresh database for this question (several questions share table names such as `students`):

```bash
createdb ict371_q02
psql -d ict371_q02 -f run_all.sql
```

Files run in order: schema, function, procedure, trigger, view, index, scheduled job, data load, tests.
The data load (`08_load_data.sql`) runs after the trigger/procedure exist, as the question requires.

| Part | File |
|------|------|
| (a) Tables + seed data | `01_schema_seed.sql`, `08_load_data.sql` |
| (b) Function | `02_function.sql` |
| (c) Procedure | `03_procedure.sql` |
| (d) Trigger | `04_trigger.sql` |
| (e) View | `05_view.sql` |
| (f) Index + EXPLAIN | `06_index.sql` |
| (g) Scheduled job | `07_scheduled_job.sql` |
| Demonstration queries | `09_tests.sql` |

## Index
`idx_payments_student_paid_on ON payments (student_id, paid_on)`

The query filters student_id by equality and paid_on by range. With the equality column first, PostgreSQL jumps straight to one student's payments and reads only the dates in range, already sorted. A paid_on-first index would have to scan every student's entries for those dates.

## Design notes
- fee_due is never changed; balances are always derived from the payments table.
- pr_receive_payment locks the student row, so two simultaneous payments cannot overpay.
- The audit row is written only by the AFTER INSERT trigger, never by the procedure.

## Output
_Paste screenshots / output of `09_tests.sql` and the `EXPLAIN` plan here._
