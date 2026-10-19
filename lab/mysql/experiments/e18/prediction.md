# E18 — prediction

Write this before running anything. Topic: [buffer pool, redo and undo](../../../../topics/innodb-buffer-pool-redo-undo/index.html), section 05.

Setup: session A runs `START TRANSACTION; SELECT COUNT(*) FROM orders;` and stays
open. Session B runs 200,000 `UPDATE`s that change `note`, spread over 1,000 rows
(each row changed about 200 times). Sample `trx_rseg_history_len` and the size of
the `undo_00*` files every 5 seconds.

1. Peak history list length and undo tablespace size while A is open.
   TODO
2. In A, `SELECT note FROM orders WHERE id = <one of the 1,000 rows>`: how much slower than the same query in a fresh session, and why?
   TODO
3. After A commits, how long until history list length is back near 0?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
