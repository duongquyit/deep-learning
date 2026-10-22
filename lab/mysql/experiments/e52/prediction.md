# E52 — prediction

Write this before running anything. Topic: [Pagination: offset and keyset](../../../../topics/pagination-keyset/index.html), section 05.

Setup: MySQL 8.4 on the lab, `orders` with 5M rows and index
`(user_id, created_at)`; one user with 200,000 orders; buffer pool 128 MB.
Query: `SELECT id, created_at, total_minor … WHERE user_id = ? ORDER BY created_at DESC, id DESC LIMIT 20 OFFSET ?`.

1. `Handler_read_prev` at OFFSET 0, 1,000, 10,000, 100,000, 199,980
   TODO
2. `Innodb_buffer_pool_reads` (disk reads) and latency for each, first run after restart and second run
   TODO
3. The same positions with a deferred join and with keyset: entries read, disk reads, latency
   TODO
4. At what OFFSET does the plain query take longer than 100 ms cold? Warm?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
