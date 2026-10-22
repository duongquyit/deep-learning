# E38 — prediction

Write this before running anything. Topic: [caching and invalidation](../../../../topics/caching-invalidation/index.html), section 05.

Setup: `products (id, price)` with 100 rows in MySQL 8.4, Redis 7, a Node script.
Part A forces the interleavings of the section 01 widget with `sleep` calls.
Part B removes the sleeps: 20 readers and 2 writers for 5 minutes on the 100
keys, TTL 30 minutes; a checker compares Redis with MySQL every 200 ms and counts
keys that stay different for more than 1 second.

1. Part A: which of the five write paths leave an old price in the cache?
   TODO
2. Part B, "set cache after write": stale keys counted
   TODO
3. Part B, "delete then write": stale keys counted
   TODO
4. Part B, "write then delete": stale keys counted
   TODO
5. Part B, "write then delete" with the fill reading from a replica: stale keys counted (open question 31)
   TODO
6. Part B, version check and double delete: stale keys counted
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
