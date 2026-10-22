# E54 — prediction

Write this before running anything. Topic: [Pagination: offset and keyset](../../../../topics/pagination-keyset/index.html), section 05.

Setup: MySQL 8.4, one user with 10,000 orders. Reader script pages through all
of them, 50 per page, 100 ms between pages. Writer script, at the same time,
inserts 5 new orders and deletes 5 random existing orders of that user every second.

1. With offset: how many ids are returned twice, and how many ids that existed at the start (and were not deleted) are never returned?
   TODO
2. The same with keyset on `(created_at, id)`
   TODO
3. With keyset on `created_at` only, where `created_at` is `DATETIME` without fractions and inserts come in bursts of 5 in the same second
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
