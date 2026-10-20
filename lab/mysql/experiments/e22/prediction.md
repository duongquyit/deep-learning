# E22 — prediction

Write this before running anything. Topic: [locking and deadlocks](../../../../topics/innodb-locking-deadlock/index.html), section 05.
This is the Month 1 Week 4 "reproduce a lost update and a deadlock by hand" item.

Setup: `accounts (id INT PRIMARY KEY, balance BIGINT)` with `(7, 1000)` and `(9, 1000)`.

1. Lost update: A and B each `SELECT balance` for id 7, compute a new value in the client (A −100, B −30), then `UPDATE … SET balance = <value>`. Final balance?
   TODO
2. The same with `UPDATE … SET balance = balance - ?`. Final balance? Did anyone wait?
   TODO
3. The same with `SELECT … FOR UPDATE` before computing. Who waits, at which statement?
   TODO
4. Crossed transfer (A: 7 then 9, B: 9 then 7). Which session gets ERROR 1213? What does `LATEST DETECTED DEADLOCK` list as held and waited locks?
   TODO
5. The same with both sessions locking `ORDER BY id` first. What happens instead?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
