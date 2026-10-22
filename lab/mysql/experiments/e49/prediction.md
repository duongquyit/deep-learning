# E49 — prediction

Write this before running anything. Topic: [Layering and business invariants](../../../../topics/layering-business-invariants/index.html), section 05.

Setup: MySQL 8.4, a table with `amount_minor BIGINT`, `amount_dec DECIMAL(15,2)`,
`amount_dbl DOUBLE`. A Node 22 script reads with mysql2 3.x in three configs:
default; `supportBigNumbers: true`; `supportBigNumbers: true, bigNumberStrings: true`.

1. Result type of `SUM(amount_minor)`, `AVG(amount_minor)`, `SUM(amount_dbl)` (read it with `CREATE TABLE t AS SELECT …` then `SHOW CREATE TABLE`)
   TODO
2. `ROUND(2.5)`, `ROUND(-2.5)`, `ROUND(2.5e0)`, `ROUND(0.125, 2)`, `ROUND(0.125e0, 2)` on 8.4
   TODO
3. For each mysql2 config: the JavaScript value and `typeof` for `BIGINT` 9007199254740991, 9007199254740993, and for `SUM(amount_minor)`
   TODO
4. Time to read 10,000 rows of `BIGINT` with each config plus a `typeCast` that returns `BigInt` (open question 40)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
