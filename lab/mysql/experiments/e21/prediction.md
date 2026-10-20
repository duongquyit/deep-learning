# E21 — prediction

Write this before running anything. Topic: [locking and deadlocks](../../../../topics/innodb-locking-deadlock/index.html), section 05.

Setup: `t (id INT PRIMARY KEY, age INT, note VARCHAR(10), KEY idx_age (age))`
with rows `(5, 10, 'a')`, `(7, 20, 'b')`, `(10, 30, 'c')`. Session A runs one
statement and stays open; session B reads `performance_schema.data_locks`, then
tries each INSERT with `SET innodb_lock_wait_timeout = 2`.

For each statement, under REPEATABLE READ and READ COMMITTED: the rows of
`data_locks` (index, lock_mode, lock_data), and which of the INSERTs
`(6, 15)`, `(8, 25)`, `(11, 35)`, `(12, 20)` time out.

1. `SELECT * FROM t WHERE id = 7 FOR UPDATE`
   TODO
2. `SELECT * FROM t WHERE id = 8 FOR UPDATE`
   TODO
3. `SELECT * FROM t WHERE age = 20 FOR UPDATE`
   TODO
4. `SELECT * FROM t WHERE age = 25 FOR UPDATE`
   TODO
5. `UPDATE t SET note = 'x' WHERE note = 'b'`
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
