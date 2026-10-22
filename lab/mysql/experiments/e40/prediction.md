# E40 — prediction

Write this before running anything. Topic: [caching and invalidation](../../../../topics/caching-invalidation/index.html), section 05.

Setup: 1,000,000 keys of about 1 KB, accessed with a Zipf distribution (s = 1)
by a script, Redis 7 with `maxmemory` set to hold 1%, 5% and 20% of the keys.
Read `keyspace_hits` and `keyspace_misses` before and after each run.

1. Hit ratio at 1%, 5%, 20% with `allkeys-lru`
   TODO
2. Same with `allkeys-lfu` (open question 32)
   TODO
3. A job scans 200,000 rarely used keys once in the middle of the run: hit ratio drop with each policy
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
