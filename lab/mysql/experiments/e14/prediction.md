# E14 — prediction

Write this before running anything. Topic: [index write cost](../../../../topics/index-write-cost/index.html), section 05.

Setup: buffer pool 128MB, `orders` with 5,000,000 rows and 5 secondary indexes
(far larger than the buffer pool). Insert 200,000 more rows with random `user_id`,
once with `innodb_change_buffering = all` and once with `none`, restarting the
server between runs so both start cold.

1. Insert time with `all` and with `none`. Which is faster, and by roughly how much?
   TODO
2. `Innodb_buffer_pool_reads` during each insert run.
   TODO
3. `ibuf_merges` and the change buffer size (`SHOW ENGINE INNODB STATUS`) right after the `all` run.
   TODO
4. Then run `SELECT COUNT(*) FROM orders FORCE INDEX (idx_user_id) WHERE user_id BETWEEN 1 AND 20000` after each run. Which run makes this read slower, and why?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
