# E43 — prediction

Write this before running anything. Topic: [replication and read-your-writes](../../../../topics/replication-read-your-writes/index.html), section 05.

Setup: as E41. Install the semi-sync plugins (`rpl_semi_sync_source`,
`rpl_semi_sync_replica`), wait point `AFTER_SYNC`, default timeout. A script
commits single-row inserts continuously from 8 clients and records each commit's
latency.

1. Commit p50 and p99, async vs semi-sync
   TODO
2. `docker stop` the replica: how long does the first commit after that wait, and when does the source switch to async?
   TODO
3. Which status variables show the switch (`Rpl_semi_sync_source_status`, `Rpl_semi_sync_source_no_tx`, others)?
   TODO
4. Start the replica again: when does the source return to semi-sync?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
