# E12 — prediction

Write this before running anything. Topic: [composite index and query plans](../../../../topics/composite-index-query-plan/index.html), section 05.

Setup: as E9, `idx_total` visible. `total` is uniform between 10,000 and 5,010,000.

1. At what X in `WHERE total > X` does the plan switch from `range` on `idx_total` to `ALL`? As a fraction of the table, estimated and actual?
   TODO
2. Just past the switch (plan `ALL`): is the full scan actually faster than `FORCE INDEX (idx_total)`? Predict p95 for both, warm buffer pool.
   TODO
3. `EXPLAIN SELECT * FROM orders WHERE note LIKE 'c%' AND status = 'cancelled'`: `filtered` before and after `ANALYZE TABLE orders UPDATE HISTOGRAM ON status WITH 8 BUCKETS`, while `status` is still in `idx_usc`?
   TODO
4. Same, after dropping `status` from every index (or on a copy without it)?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
