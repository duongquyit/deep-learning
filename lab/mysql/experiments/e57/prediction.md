# E57 — prediction

Write this before running anything. Topic: [Test strategy with a real MySQL](../../../../topics/test-strategy-real-db/index.html), section 05.

This is the Month 2 exit criterion: tests catch a deliberately introduced
invariant violation.

Setup: the Month 2 ledger service on MySQL 8.4 in a container. Two tests for
"balance never negative": (a) 20 concurrent withdrawals through a barrier;
(b) deterministic interleaving using `performance_schema.data_lock_waits`.
Three patches: remove `FOR UPDATE`; remove the `balance_minor >= ?` condition;
make the repository commit on its own.

1. For each patch, does (a) go red, and in how many of 50 runs?
   TODO
2. For each patch, does (b) go red on the first run?
   TODO
3. Which patch does neither test catch, and which test would?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
