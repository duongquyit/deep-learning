# E9 — prediction

Write this before running anything. Topic: [composite index and query plans](../../../../topics/composite-index-query-plan/index.html), section 05.

Setup: `orders`, 5,000,000 rows, `idx_usc (user_id, status, created_at)` added,
`idx_user_id` and `idx_status` made `INVISIBLE`, `ANALYZE TABLE orders` run.
First list your own entries for users 41–43:
`SELECT user_id, status, created_at, id FROM orders WHERE user_id BETWEEN 41 AND 43 ORDER BY user_id, status, created_at;`

For each query, predict `type`, `key_len`, `used_key_parts` (from `EXPLAIN FORMAT=JSON`) and `rows`.

1. `WHERE user_id = 42`
   TODO
2. `WHERE user_id = 42 AND status = 'paid'`
   TODO
3. `WHERE user_id = 42 AND status = 'paid' AND created_at >= '2025-02-05'`
   TODO
4. `WHERE user_id = 42 AND created_at >= '2025-02-05'`
   TODO
5. `WHERE status = 'paid'`
   TODO
6. `WHERE status = 'paid' AND created_at >= '2025-02-05'`
   TODO
7. `WHERE user_id BETWEEN 41 AND 43 AND status = 'paid'` — which query has `key_len` and `used_key_parts` that disagree, and why?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
