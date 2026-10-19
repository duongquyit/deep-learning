# E20 — prediction

Write this before running anything. Topic: [MVCC and read views](../../../../topics/mvcc-read-view/index.html), section 05.

Setup: `orders` with 5,000,000 rows and `idx_user_id`. Session A runs
`START TRANSACTION WITH CONSISTENT SNAPSHOT`. Session B changes `user_id` on
5,000 rows whose `user_id` is between 1 and 2000, then commits.

1. `EXPLAIN SELECT COUNT(*) FROM orders WHERE user_id BETWEEN 1 AND 2000` — does it still say `Using index`?
   TODO
2. `Innodb_buffer_pool_read_requests` for that query in A, and in a fresh session. Which is larger, and by roughly how much?
   TODO
3. After A commits and purge catches up, does the fresh-session number change?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
