# E32 — prediction

Write this before running anything. Topic: [transactional outbox](../../../../topics/transactional-outbox/index.html), section 05.

Setup: the relay from section 04, batch 100, publishing to a local endpoint.
Each event's payload carries its commit time; the endpoint logs receive time.
Read `Com_select` and `Com_update` from `SHOW GLOBAL STATUS` before and after.

For sleep intervals of 100 ms and 1 s, at 10 and 1,000 events per second:

1. Added latency p50 and p99
   TODO
2. Polling queries per second with no events at all
   TODO
3. At 1,000 events/s and 1 s sleep: how many batches per wake-up, and does the relay keep up?
   TODO
4. How far are the numbers from the calculator in section 02?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
