# E11 — prediction

Write this before running anything. Topic: [composite index and query plans](../../../../topics/composite-index-query-plan/index.html), section 05.

Query: `SELECT * FROM orders WHERE user_id = ? AND status = 'paid' AND created_at >= ? ORDER BY created_at DESC LIMIT 20`

Index A: `(user_id, status, created_at)`. Index B: `(user_id, created_at, status)`.
Only one of them visible at a time.

1. For each index: `type`, `key_len`, `Extra`. Filesort or not?
   TODO
2. For a normal user (about 10 orders): `Handler_read_next` and p95 latency for A and B. Which wins, by how much?
   TODO
3. After adding 2,000 orders to one user (`INSERT … SELECT`), most of them `paid` and spread over a year: same numbers. Does the winner change?
   TODO
4. Which index would you ship for a list page that runs this query, and what would make you change your mind?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
