# E45 — prediction

Write this before running anything. Topic: [distributed consistency](../../../../topics/distributed-consistency/index.html), section 05.

Setup: as E44, network healthy. A Node script holds one connection to the
primary and one to a secondary. Each iteration: `UPDATE` a counter on the
primary, then immediately `SELECT` it on the secondary. 10,000 iterations per
setting of `group_replication_consistency` (set per session).

1. Share of stale reads on the secondary with `EVENTUAL`, `BEFORE`, `AFTER`
   TODO
2. p50 and p99 of write latency and read latency for each level
   TODO
3. Add 20 ms delay to one secondary (`tc qdisc add dev eth0 root netem delay 20ms`). How much does each level slow down, and for writes or reads?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
