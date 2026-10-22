# E39 — prediction

Write this before running anything. Topic: [caching and invalidation](../../../../topics/caching-invalidation/index.html), section 05.

Setup: one hot key read 2,000 times per second (k6, constant arrival rate). On a
miss, the recompute runs a real aggregate query plus `SELECT SLEEP(0.3)`. Let the
key expire and record the number of recompute queries (a counter in code) and
reader p99 over the 5 seconds around expiry.

1. No protection: recompute queries and p99
   TODO
2. Lock (single flight): recompute queries, how many readers wait, p99
   TODO
3. Stale-while-revalidate: recompute queries, stale responses, p99
   TODO
4. XFetch with β = 1: recompute queries and when they happen relative to expiry
   TODO
5. How much worse is "no protection" than the page's model once MySQL slows under the load?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
