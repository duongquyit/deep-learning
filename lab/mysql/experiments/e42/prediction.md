# E42 — prediction

Write this before running anything. Topic: [replication and read-your-writes](../../../../topics/replication-read-your-writes/index.html), section 05.

Setup: as E41, plus a heartbeat table written by the primary every second. A
table with 2,000,000 rows to delete. A background script writes 200 rows per
second into another table. Sample every second: heartbeat lag, lag from
`performance_schema.replication_applier_status_by_worker` timestamps, and
`Seconds_Behind_Source`.

1. One `DELETE` of 2,000,000 rows: how long on the primary, maximum lag by each of the three measures, and their shapes over time
   TODO
2. 400 batches of 5,000 rows with no pause: maximum lag
   TODO
3. Same batches, pausing while heartbeat lag is above 2 s: maximum lag and total job time
   TODO
4. Is applying the big delete on the replica slower or faster than running it on the primary? (open question 33)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
