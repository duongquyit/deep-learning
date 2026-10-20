# E23 — prediction

Write this before running anything. Topic: [locking and deadlocks](../../../../topics/innodb-locking-deadlock/index.html), section 05.

Setup: `t` with `idx_age` values 10, 20, 30, 40 (PK 5, 7, 10, 12), REPEATABLE READ.

1. `SELECT * FROM t WHERE age BETWEEN 15 AND 25 FOR UPDATE`: lock_mode on the entry `(30, 10)`. Next-key or gap only?
   TODO
2. `SELECT * FROM t WHERE id BETWEEN 6 AND 8 FOR UPDATE`: lock_mode on id 10.
   TODO
3. In each case, is `INSERT` with age 35 (or id 11) blocked?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
