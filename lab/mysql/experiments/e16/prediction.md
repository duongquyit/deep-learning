# E16 — prediction

Write this before running anything. Topic: [buffer pool, redo and undo](../../../../topics/innodb-buffer-pool-redo-undo/index.html), section 05.

Setup: buffer pool 128MB, `orders` with 5,000,000 rows. Warm up with a fixed set
of point queries on `orders` (about 20MB of pages) until `Innodb_buffer_pool_reads`
stops growing. Then run one full scan (`SELECT COUNT(note) FROM orders`), then
run the point-query set again.

1. `Innodb_buffer_pool_reads` for the second run of the point queries with `innodb_old_blocks_time = 1000`.
   TODO
2. The same with `innodb_old_blocks_time = 0`.
   TODO
3. "Pages made young" and "not young" in `SHOW ENGINE INNODB STATUS` during the scan, in both cases.
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
