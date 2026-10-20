# E19 — prediction

Write this before running anything. Topic: [MVCC and read views](../../../../topics/mvcc-read-view/index.html), section 05.

Setup: `accounts (id INT PRIMARY KEY, balance BIGINT)` with `(7, 1000)`. Two
sessions, A and B, run the script in section 04 of the page step by step.

1. Under REPEATABLE READ, what does each of A's four reads return (plain `SELECT` after B commits, `FOR UPDATE`, after A's `UPDATE`)?
   TODO
2. The same under READ COMMITTED.
   TODO
3. Variant: A runs `START TRANSACTION WITH CONSISTENT SNAPSHOT`, then B updates and commits, then A runs its first `SELECT`. What does A see, and how is it different from plain `START TRANSACTION`?
   TODO
4. Variant: instead of `balance = balance - 50`, A writes `SET balance = 950` computed from its first read. Final balance?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
