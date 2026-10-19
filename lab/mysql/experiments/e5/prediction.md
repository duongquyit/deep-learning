# E5 — prediction

Write this before running `./lab.sh e5`. The script refuses to run while this
file still contains the word TODO.

Setup: `orders` (PK `BIGINT`) and `orders_uuid` (PK `CHAR(36)`, random UUIDv4),
5,000,000 rows each, the same 4 secondary indexes (`idx_user_id`,
`idx_created_at`, `idx_status`, `idx_total`).

1. Size of `idx_user_id` in each table, in MB, and the ratio between them. How did you get the numbers?
   TODO
2. Will the ratio be the same for all 4 secondary indexes? Which one differs most, and why?
   TODO
3. PRIMARY of `orders_uuid` versus PRIMARY of `orders`: bigger or smaller, by how much, and which effect dominates (wider key, or emptier leaves from random inserts)?
   TODO

## After the run

Compare with the results file. Where the prediction was wrong, write why here.
