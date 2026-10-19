# E10 — prediction

Write this before running anything. Topic: [composite index and query plans](../../../../topics/composite-index-query-plan/index.html), section 05.

Setup: as E9. Query:
`SELECT COUNT(note) FROM orders WHERE user_id BETWEEN 41 AND 43 AND status = 'paid'`
(`note` is not in the index, so every matching row needs a PRIMARY lookup.)

1. From your list of entries for users 41–43: how many entries are in the scanned range, and how many pass `status = 'paid'`?
   TODO
2. `Handler_read_next` with ICP on, and with ICP off (`SET optimizer_switch = 'index_condition_pushdown=off'`)?
   TODO
3. `./lab.sh reads` cold: pages of `idx_usc` and of `PRIMARY` read, ICP on vs off?
   TODO
4. Same query with `BETWEEN 1 AND 5000`: does the page difference grow in proportion to the lookup difference? Why or why not?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
