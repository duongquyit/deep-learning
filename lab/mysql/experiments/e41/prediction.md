# E41 — prediction

Write this before running anything. Topic: [replication and read-your-writes](../../../../topics/replication-read-your-writes/index.html), section 05.

Setup: MySQL 8.4 primary and one replica in Docker, GTID on, async. A Node
script with two pools. It writes one row on the primary, then reads it on the
replica after 0, 1, 5, 20 and 100 ms; 1,000 times per delay. Run once with the
primary idle and once while another script writes 500 rows per second.

1. Percentage of stale reads at each delay, primary idle
   TODO
2. Same with 500 writes per second in the background
   TODO
3. With `session_track_gtids = OWN_GTID` and `WAIT_FOR_EXECUTED_GTID_SET(gtid, 1)` before each read: stale reads, and added wait p50 and p99
   TODO
4. Does `WAIT_FOR_EXECUTED_GTID_SET` accept a fractional timeout such as 0.2? (open question 34)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
