# E6 — prediction

Write this before running `./lab.sh e6`. The script refuses to run while this
file still contains the word TODO.

Setup: `orders`, 5,000,000 rows, PK `BIGINT`. The script picks a `user_id` with
exactly 3 orders and runs each query once on a freshly restarted server (empty
buffer pool), once warm, then 500 times for latency.

Query A: `SELECT * FROM orders WHERE user_id = ?`
Query B: `SELECT id FROM orders WHERE user_id = ?`

1. How many levels do `idx_user_id` and `PRIMARY` have? Show the arithmetic.
   TODO
2. Query A, cold: how many pages of `idx_user_id` and how many pages of `PRIMARY` end up in the buffer pool? Is there any case where it is fewer than you would naively count?
   TODO
3. Query A: `Handler_read_key` and `Handler_read_next`?
   TODO
4. Query B, cold: pages of `PRIMARY` in the buffer pool? What does `EXPLAIN` show in `Extra`?
   TODO
5. Warm: roughly how many page accesses for A and for B? Which is faster at p95, and by about how much?
   TODO

## After the run

Compare with the results file. Where the prediction was wrong, write why here.
