# E31 — prediction

Write this before running anything. Topic: [transactional outbox](../../../../topics/transactional-outbox/index.html), section 05.

Part A, by hand in two `./lab.sh shell` sessions plus a third for the relay
query, replaying the stepper in section 02: T1 inserts into `outbox` and stays
open; T2 inserts and commits; the relay runs `WHERE id > 40`; T1 commits.

1. Which ids does the relay query return, and which id is never sent with an id cursor?
   TODO

Part B, a Node script: 8 clients insert orders continuously for 60 s; two
relays run `WHERE sent_at IS NULL ORDER BY id LIMIT 100 FOR UPDATE SKIP LOCKED`.
Kill one relay with `SIGKILL` every 10 s and restart it.

2. Events lost (in `orders` but never received)?
   TODO
3. Events received twice?
   TODO
4. While a relay holds a batch, what does `data_locks` show on `idx_unsent`, and do inserts into `outbox` wait? (open question 25)
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
