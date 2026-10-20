# E26 — prediction

Write this before running anything. Topic: [concurrency control strategies](../../../../topics/concurrency-control-strategies/index.html), section 05.

Setup: `orders (id, status)` with row `(7, 'paid')`, and `accounts` row `(42, 10)`.
Two mysql2 pools: default flags, and `flags: ['-FOUND_ROWS']`. Print the whole
result object of each statement. Run the same statements in the `mysql` client.

For each statement and each pool: `affectedRows` and `changedRows`; and what the `mysql` client prints.

1. `UPDATE orders SET status = 'paid' WHERE id = 7` (no change in value)
   TODO
2. `UPDATE orders SET status = 'shipped' WHERE id = 7`
   TODO
3. `UPDATE accounts SET balance = balance - 30 WHERE id = 42 AND balance >= 30` (not enough money)
   TODO
4. `UPDATE accounts SET balance = balance - 30 WHERE id = 99 AND balance >= 30` (no such account)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
