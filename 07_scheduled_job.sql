-- ICT371 Q2 (g): pr_refresh_collections + pg_cron
CREATE OR REPLACE PROCEDURE pr_refresh_collections(p_day DATE)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_day IS NULL THEN
        RAISE EXCEPTION 'p_day is required';
    END IF;

    -- Upsert: an existing summary row for the date is replaced, not added to
    INSERT INTO daily_collections (collection_date, payment_count, total_amount)
    SELECT p_day, COUNT(*), COALESCE(SUM(amount), 0)
    FROM payments
    WHERE paid_on = p_day
    ON CONFLICT (collection_date) DO UPDATE
    SET payment_count = EXCLUDED.payment_count,
        total_amount  = EXCLUDED.total_amount;
END;
$$;

CREATE EXTENSION IF NOT EXISTS pg_cron;

-- Daily at 01:00 for the previous day
SELECT cron.schedule(
    'q02_collections_daily',
    '0 1 * * *',
    $$CALL pr_refresh_collections(CURRENT_DATE - 1)$$
);

-- Inspect:
-- SELECT jobid, jobname, schedule, command FROM cron.job;
-- SELECT * FROM cron.job_run_details ORDER BY start_time DESC LIMIT 5;
