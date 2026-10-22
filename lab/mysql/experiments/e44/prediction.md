# E44 — prediction

Write this before running anything. Topic: [distributed consistency](../../../../topics/distributed-consistency/index.html), section 05.

Setup: three MySQL 8.4 containers running Group Replication in single-primary
mode, `group_replication_unreachable_majority_timeout` left at its default (0).
A script inserts one row per 100 ms into the primary and logs each commit's
latency or error. A second loop reads `performance_schema.replication_group_members`
on every member each second.

1. `docker network disconnect` the primary from the other two. What does the next `INSERT` on the old primary do: block, error, or commit? For how long?
   TODO
2. On the majority side: is a new primary elected, and after how many seconds?
   TODO
3. What `MEMBER_STATE` does each side report for the others?
   TODO
4. Reconnect the network. What happens to the transaction that was waiting on the old primary, and to the old primary itself?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
