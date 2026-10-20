# Learning Log

> Running record of learning sessions, competency levels, and open questions.
> Format follows [TECHNICAL_GROWTH.md](TECHNICAL_GROWTH.md) Section 8; the schedule it feeds is [ROADMAP.md](ROADMAP.md).
>
> Rules this file enforces on itself:
> - A level is a claim about demonstrated competency, backed by a linked artifact. No artifact, no level.
> - Level 3+ requires more than reading or writing notes: a measurement, an experiment, or real code (Principle 6).
> - Fields only I can answer (what I believed before, what I got wrong) stay marked `TODO` until I fill them. An empty field is honest; an invented one corrupts the baseline.
> - A model or simulation built from reading is not an observation. If nothing was measured, the experiments field stays empty and says so.
>
> Sessions are newest first.

## Writing an entry

Every research or study session gets an entry here **and** a mark in [ROADMAP.md](ROADMAP.md), in the same session as the work. Doing one without the other is a defect; the next session should not have to guess what actually happened.

1. Add a dated `## YYYY-MM-DD — Topic` section at the top of the Sessions area, with these fields: topic and objective, output (link the artifact), what it covers, initial understanding, mistakes and misconceptions corrected, experiments and results, competency level, remaining questions, next step.
2. Update the competency matrix rows the session touched — level, evidence link, date, and what it would take to reach the next level. Add rows for new topics.
3. Move anything unresolved into Open questions, and anything to be measured later into Pending verification.
4. Mark the roadmap: tick the week, deliverable, or exit criterion advanced, or add a row to its Unplanned work table if the session was off-plan.

The field definitions come from [TECHNICAL_GROWTH.md](TECHNICAL_GROWTH.md) Section 8; the evidence standard that governs what may be written is in Section 10.

## Competency matrix

Levels: 0 unfamiliar · 1 explain basics with help · 2 implement a standard solution · 3 explain internals, trade-offs, edge cases · 4 diagnose unfamiliar problems independently.

| Topic | Level | Evidence | Date | To reach next level |
|---|---|---|---|---|
| B+tree structure, fan-out, tree height | 2 (prov.) | [btree-index-internals](../topics/btree-index-internals/index.html) §02 | 2026-10-14 | Predict height + page reads for an unseen table, then confirm with a real index |
| Page layout (slotted page, line pointers) | 2 (prov.) | same, §04 | 2026-10-14 | Inspect a real page (`pageinspect` / `innodb_ruby`) and match it to the model |
| Split mechanics (leaf vs internal, rightmost split, fillfactor) | 2 (prov.) | same, §03 | 2026-10-14 | Exercise E2 below: measure index size for sequential vs random keys |
| Buffer pool and eviction | 2 (prov.) | same, §05 | 2026-10-14 | Exercise E3: cold vs warm cache, read real hit ratios |
| Pin / latch / lock distinction | 2 (prov.) | same, §05 | 2026-10-14 | Observe lock waits under concurrency (Month 1 Week 4) |
| WAL ordering (WAL before data page) | 1 | same, §06 | 2026-10-14 | Trace a commit's actual fsync behaviour; InnoDB redo log equivalent |
| Reading `EXPLAIN (ANALYZE, BUFFERS)` | 2 (prov.) | same, §07 | 2026-10-14 | Read plans I did not write, on tables I did not design |
| Covering index / Index Only Scan and its cost | 2 (prov.) | same, §08 | 2026-10-14 | Exercise E4: measure the page-count difference myself |
| TOAST and the real cost of `SELECT *` | 2 (prov.) | same, §08 | 2026-10-14 | Measure a wide-column table; find the InnoDB off-page equivalent |
| Heap, TID, MVCC versions, HOT, bloat | 2 (prov.) | same, §09 | 2026-10-14 | Reproduce bloat and watch autovacuum fail to keep up |
| InnoDB specifics (clustered index, secondary→PK lookup, undo log) | 2 (prov.) | [clustered-vs-secondary-index](../topics/clustered-vs-secondary-index/index.html) §01–§04 | 2026-10-19 | Exercises E5 and E6: measure index sizes and buffer-pool reads on MySQL 8.4 and match them to the model |
| Clustered vs secondary index (leaf contents, PK vs TID as pointer, covering by PK) | 2 (prov.) | same, §01–§02 | 2026-10-19 | Predict `EXPLAIN` and page reads for an unseen query on both engines, then confirm (E6) |
| Index write cost of UPDATE (InnoDB in place vs PostgreSQL HOT / non-HOT) | 2 (prov.) | same, §03 | 2026-10-19 | Exercise E7: measure `n_tup_hot_upd` and index growth |
| Clustered-index page split and PK choice (sequential vs random) | 2 (prov.) | same, §04 | 2026-10-19 | Exercise E8: count `index_page_splits` for sequential vs UUIDv4 keys |
| Composite index: leftmost prefix, range stops later columns, `key_len` vs `used_key_parts` | 2 (prov.) | [composite-index-query-plan](../topics/composite-index-query-plan/index.html) §01–§02 | 2026-10-19 | Exercise E9: predict `type`, `key_len` and `used_key_parts` for 7 queries on the 5M lab table, then confirm |
| Column order (equality, sort, range) and avoiding filesort | 2 (prov.) | same, §03 | 2026-10-19 | Exercise E11: two column orders, measure `Handler_read_next` and latency for a heavy user |
| Index Condition Pushdown, `Using index condition` vs `Using where` | 2 (prov.) | same, §04 | 2026-10-19 | Exercise E10: `Handler_read_next` and page reads with ICP on and off |
| Optimizer estimates: index dives, cardinality, histograms, why an index is skipped | 2 (prov.) | same, §05 | 2026-10-19 | Exercise E12: find the range→ALL threshold on the lab and check whether the choice was right by latency |
| Reading MySQL `EXPLAIN` / `EXPLAIN ANALYZE` (`type`, `key_len`, `rows`, `filtered`, `Extra`) | 2 (prov.) | same, §06 | 2026-10-19 | Read plans for queries I did not write, including a join, and explain every estimate-vs-actual gap |
| Write cost per statement: which trees an INSERT / UPDATE / DELETE touches, delete-mark + insert on secondary keys | 2 (prov.) | [index-write-cost](../topics/index-write-cost/index.html) §01–§02 | 2026-10-19 | Exercise E13: insert time and size with 0, 2, 5, 8 secondary indexes, explained tree by tree |
| Page fill under sequential vs random inserts, page merge and `MERGE_THRESHOLD` | 2 (prov.) | same, §02 | 2026-10-19 | Exercises E8 and E15: rows per leaf for each PK type; merge counters and file size after a large delete |
| Change buffer (what it defers, which indexes, 8.4 default `none`) | 2 (prov.) | same, §02 | 2026-10-19 | Exercise E14: insert time and buffer-pool reads with change buffering `all` vs `none` |
| PK choice and its effect on every index (BIGINT, UUIDv4 text/binary, UUIDv7) | 2 (prov.) | same, §02 | 2026-10-19 | Exercises E5 and E8, then justify a PK choice for a real table at work with numbers |
| InnoDB buffer pool: midpoint LRU, `innodb_old_blocks_time`, page cleaner, dirty pages | 2 (prov.) | [innodb-buffer-pool-redo-undo](../topics/innodb-buffer-pool-redo-undo/index.html) §02 | 2026-10-19 | Exercise E16: scan resistance with `innodb_old_blocks_time` 1000 vs 0, measured in buffer-pool reads |
| Redo log, LSN, checkpoint age, `innodb_flush_log_at_trx_commit` and what each value loses | 2 (prov.) | same, §01–§02 | 2026-10-19 | Exercise E17: commit throughput for 1, 2, 0 with 1 and 16 clients; read the three LSNs during a write burst |
| Undo log, purge, history list length, long transactions | 2 (prov.) | same, §02 | 2026-10-19 | Exercise E18: hold a read view open and watch history length and undo size |
| Doublewrite and crash recovery order (doublewrite, redo from checkpoint, rollback) | 2 (prov.) | same, §02 | 2026-10-19 | Kill the lab server mid-write and read the recovery messages in the error log |
| MVCC: version chain, read view and the visibility rule | 2 (prov.) | [mvcc-read-view](../topics/mvcc-read-view/index.html) §02 | 2026-10-19 | Predict which version a view sees for a chain I did not build; E19 variants |
| Isolation levels in InnoDB (RR snapshot at first read, RC per statement) and which anomalies each allows | 2 (prov.) | same, §01–§02 | 2026-10-19 | Exercise E19 under RR and RC, including `WITH CONSISTENT SNAPSHOT` |
| Consistent read vs locking read / DML (current read) and the lost-update trap | 2 (prov.) | same, §02, §04 | 2026-10-19 | Reproduce a lost update in the lab, then fix it two ways (Month 1 Week 4) |
| MVCC on secondary indexes (no hidden columns, fallback to PRIMARY) | 2 (prov.) | same, §02 | 2026-10-19 | Exercise E20: covering read cost on a table under concurrent writes |
| InnoDB lock types (S/X, IS/IX, record, gap, next-key, insert intention) and what each statement locks under RR and RC | 2 (prov.) | [innodb-locking-deadlock](../topics/innodb-locking-deadlock/index.html) §01–§02 | 2026-10-19 | Exercise E21: match `data_locks` for 5 statements under RR and RC, and predict which inserts block |
| Lost update: four fixes and their cost | 2 (prov.) | same, §02 | 2026-10-19 | Exercise E22: reproduce and fix it two ways |
| Deadlocks: detection, victim, 1213 vs 1205, reading `LATEST DETECTED DEADLOCK`, lock ordering | 2 (prov.) | same, §02, §04 | 2026-10-19 | Exercise E22: reproduce a crossed-transfer deadlock and read the report; then diagnose one from work |
| Lost update vs check-then-act on a balance; why a transaction under RR does not prevent either | 2 (prov.) | [concurrency-control-strategies](../topics/concurrency-control-strategies/index.html) §01–§02 | 2026-10-20 | Exercise E24: reproduce both failures with 50 concurrent withdrawals and count the missing money |
| Three concurrency-control strategies (conditional UPDATE, `FOR UPDATE`, version column): mechanism, cost, when to use | 2 (prov.) | same, §02–§03, §06 | 2026-10-20 | Exercise E25: throughput, p99 and retries of the three at 1, 8, 32 clients; then choose and defend one for a real endpoint at work |
| Checking write results: affected rows (changed vs matched, `CLIENT_FOUND_ROWS`, mysql2 default) | 2 (prov.) | same, §02, §04 | 2026-10-20 | Exercise E26: print mysql2 results with and without `FOUND_ROWS` |
| Hot-row throughput: lock hold time as the ceiling, and the alternatives (append-only ledger, split balance, batching) | 2 (prov.) | same, §02 | 2026-10-20 | Exercise E25, then compare with the calculator; resolve open question 21 |
| Delivery semantics: at-most-once, at-least-once, effectively-once; why a timeout means "unknown" | 2 (prov.) | [idempotency-retries](../topics/idempotency-retries/index.html) §01, §03 | 2026-10-20 | Explain the three timeout cases for an endpoint at work and what its clients do on each |
| Idempotency keys for a POST API: storage, fingerprint, same-transaction design vs `processing` state, 409/422, expiry | 2 (prov.) | same, §02, §04 | 2026-10-20 | Exercise E27: concurrent duplicates against a real implementation, read `data_locks` while they wait |
| Consumer-side dedup: where to write the processed marker, ack after commit | 2 (prov.) | same, §02 | 2026-10-20 | Exercise E28: kill the consumer at each point for four designs and count the effects |
| Retry policy: retryable errors, exponential backoff with full/equal jitter, attempt limits, retry budget, DLQ | 2 (prov.) | same, §02, §06 | 2026-10-20 | Exercise E29: measure a retry storm with and without jitter; then audit the retry layers of one call path at work |
| Dual write: why commit-then-send, send-then-commit and send-inside-transaction each lose events or create phantom events | 2 (prov.) | [transactional-outbox](../topics/transactional-outbox/index.html) §01 | 2026-10-20 | Exercise E30: count missing, phantom and duplicate events under injected failures |
| Transactional outbox with a polling relay: status-based reads, the id-cursor gap, `SKIP LOCKED` with several relays, ordering by aggregate, cleanup | 2 (prov.) | same, §02, §04 | 2026-10-20 | Exercise E31: reproduce the id-cursor gap, then run two relays under kills and count losses and duplicates |
| Polling vs CDC from the binlog (latency, load, ordering, operations) | 2 (prov.) | same, §02–§03 | 2026-10-20 | Exercise E32 for polling; read the outbox rows in `mysqlbinlog` output |
| Saga at concept level: compensations, orchestration vs choreography, no isolation | 1 | same, §02–§03 | 2026-10-20 | Design the compensations for one multi-service flow at work, including the intermediate states users see |

"(prov.)" = provisional. Every row above rests on one artifact I wrote myself, with no measurement behind it. Week 1 of Month 1 includes a baseline assessment (TECHNICAL_GROWTH.md Section 11) that should confirm or cut these.

## Open questions carried forward

1. **The research is PostgreSQL-shaped; the program is MySQL 8.4.** Heap, TID/`ctid`, `VACUUM`, visibility map, clock-sweep, `INCLUDE`, HOT, `fillfactor`, 8KB pages — all PostgreSQL. ROADMAP.md Month 1 and TECHNICAL_GROWTH.md Track A commit to MySQL 8.4/InnoDB, where the equivalents are different in kind, not just in name: rows live in the clustered index leaf, secondary index leaves hold the PK, old versions go to the undo log, pages are 16KB, and there is no Index Only Scan / visibility map at all. The contrast boxes in the page flag this but do not resolve it. *2026-10-19: the clustered-vs-secondary page is the first one built InnoDB-first with PostgreSQL as the comparison. That is a step toward the second option, not a decision; nothing has been run on MySQL yet.* **Decide in Week 1:** either redo the mechanism sections against InnoDB, or keep PostgreSQL deliberately as the comparison exercise Track A allows and make MySQL the primary. Do not leave both half-learned.
2. Does a `LIMIT 20` actually stop the index scan early, or does the plan materialise more rows first? The §07 trace assumes early exit.
3. The §07 numbers (50M rows, ~6.5GB table, ~1.6GB index, 24 page accesses) are estimates, not measurements. Which of them survive contact with a real table?
4. InnoDB change buffer and adaptive hash index were named but not explained. When does each actually help, and when does it hurt? *Partly answered 2026-10-19 by the index-write-cost page: what the change buffer defers, that it never applies to PRIMARY or unique indexes, and that 8.4 turned it off by default (`innodb_change_buffering = none`, with adaptive hash index also off). No measurement yet (E14); adaptive hash index still not covered.*
5. The B+tree playground splits at 3 keys per node for visibility. Does anything in my mental model secretly depend on that small fan-out rather than the real ~400?
6. The clustered-vs-secondary size calculator assumes ~69% leaf fill and a 5-byte InnoDB record header, and ignores the page directory. How far off is it on a real table (E5)?
7. The page states that InnoDB's extra cost on a secondary-index lookup is mostly buffer-pool hits (CPU and latches), not I/O. At what hit ratio does that stop being true?
8. In Claude's sandbox (MySQL 8.0.46) a histogram on `status` did not change `filtered` while `status` was still a column of an index, even an invisible one, but did on a copy of the table with no index on it. Is that the documented rule, and does 8.4 behave the same? *Partly answered 2026-10-19: the 8.4 manual (Optimizer Statistics) says the optimizer does not use histogram statistics when the range optimizer applies. Whether an invisible index counts is still open; E12 checks it on 8.4.*
9. The sandbox optimizer gave up `idx_total` at about 10% of the table *by estimate*, when only about 5% of rows matched (range estimates were roughly 2× too high). Was full scan actually faster at that point? Needs latency on both sides of the threshold (E12).
10. MySQL printed `Using index condition` for `user_id = 42 AND status = 'paid'` on `(user_id, status, created_at)`, where both conditions are already satisfied by the `ref` key. Why is the ENUM equality kept as a pushed condition?
11. The 8.4 manual (Range Optimization) says that after a range operator on a key part the optimizer "considers no more key parts", yet the 8.0.46 sandbox printed `key_len = 5` and an interval `(41 <= user_id <= 43 AND status = 'paid')` with `used_key_parts: ["user_id"]`. Which describes 8.4, and does the extra key part in the interval ever narrow the scan beyond the edges? E9 checks it.
12. With UUIDv7 generated on several app servers whose clocks differ by a few milliseconds, do PRIMARY pages still end up as full as with AUTO_INCREMENT? A variant of E8 would show it.
13. Does InnoDB's "split at the insertion point" heuristic still fire when several sessions insert interleaved AUTO_INCREMENT values into the same last page?
14. On 8.4 with change buffering off, how much slower do inserts get once the secondary indexes outgrow the buffer pool? E14.
15. With the binary log on, commit becomes two-phase (redo prepare, binlog, redo commit). How much does binlog group commit change the cost of `innodb_flush_log_at_trx_commit = 1` with `sync_binlog = 1`? The lab runs with the binlog off; needs a variant of E17.
16. At what write rate does the lab (default 100MB redo) start to stall on checkpoint age, and from what age does adaptive flushing speed up?
17. On storage with atomic 16KB writes, how much does turning off doublewrite gain? Low priority.
18. Are the exact conditions that make a covering read on a secondary index fall back to PRIMARY (delete-marked entry, page modified by a transaction newer than the view) as described, and what does it cost on a table under writes? The manual names both conditions; the per-page transaction ID detail comes from the source code and is unchecked. E20.
19. Under READ COMMITTED, an `UPDATE … WHERE` on an unindexed column uses a "semi-consistent read" to skip non-matching rows without waiting for their locks. How much does that change lock waits compared with REPEATABLE READ? Belongs to the locking page.
20. On 8.4, is the first entry past a range on a secondary index, and on the PK, locked with a next-key lock or a gap lock only? This changed across 8.0 releases; the locking page's widget avoids ranges for that reason. E23.
21. At COMMIT, does InnoDB release row locks before or after the redo log is flushed to disk? It decides whether commit time counts toward a hot row's lock hold time, which the concurrency-control page's calculator assumes it does. Read the source or measure with E25 under `innodb_flush_log_at_trx_commit` 1 and 2.
22. With a version column and 32 clients writing one row, how many attempts and how much backoff does it take for nearly every request to succeed, and how much does jittered exponential backoff help over an immediate retry? E25.
23. Three requests with the same idempotency key, the first rolls back on a business error: do the other two deadlock, as in the manual's three-session duplicate-key example? If so, how should `transfer()` handle 1213 and still return one result? E27.
24. How long should idempotency keys be kept when the client is a mobile app with an offline queue that may resend days later? Should finished keys (fingerprint and response only) be kept apart from in-flight ones?
25. Under REPEATABLE READ, which gap and next-key locks does the relay's `FOR UPDATE SKIP LOCKED` on `WHERE sent_at IS NULL ORDER BY id` take on `idx_unsent`, and do they block new inserts into the outbox? Should the relay run at READ COMMITTED? E31.
26. With ROW binlog and `binlog_row_image = FULL`, how many binlog bytes does one outbox event with a 2KB payload add, and does insert-then-delete in the same transaction double it?

## Pending verification (from the session's own exercise list)

These are written in the page as exercises; none have been run yet.

- **E1** — Build a 10M-row table; compare `EXPLAIN (ANALYZE, BUFFERS)` across Seq Scan, Index Scan, Index Only Scan.
- **E2** — Insert 1M rows with a sequential PK vs UUIDv4; compare index size and insert time; explain the gap through split behaviour. *(Directly matches ROADMAP.md Month 1 Week 3.)*
- **E3** — Restart the server, run one query twice with `BUFFERS`; separate real disk reads from OS page cache.
- **E4** — 5M-row `orders` table; run the §07 query with a plain index, then a covering index; explain the difference using the 12-step trace.
- **E5** — *Script ready: `lab/mysql/lab.sh e5`.* Two 5M-row InnoDB tables, PK `BIGINT` vs `CHAR(36)` UUIDv4, 4 secondary indexes each; compare `mysql.innodb_index_stats` sizes with the page's calculator.
- **E6** — *Script ready: `lab/mysql/lab.sh e6` (MySQL part).* Re-measure the clustered-vs-secondary §02 trace: `Innodb_buffer_pool_read_requests` / `Innodb_buffer_pool_reads` for `SELECT *` vs `SELECT id`; PostgreSQL `BUFFERS` before and after `INCLUDE (id)` + `VACUUM`.
- **E7** — HOT vs non-HOT: 1M updates on an unindexed vs an indexed column, `fillfactor` 100 vs 90; `n_tup_hot_upd` and index sizes. Same updates on InnoDB.
- **E8** — *Script ready: `lab/mysql/lab.sh e8`, also covers a time-ordered UUID.* 1M inserts with sequential vs UUIDv4 PK on InnoDB; `index_page_splits` from `INNODB_METRICS`, insert time, PRIMARY size. *(Overlaps E2; run them together in Month 1 Week 3.)*
- **Q6–Q10** — The five check questions at the end of the clustered-vs-secondary page.
- **E9** — Leftmost prefix on the 5M lab table with `idx_usc (user_id, status, created_at)` and the single-column indexes made invisible: predict and check `type`, `key_len`, `used_key_parts` for the 7 queries in §01–§02.
- **E10** — ICP on vs off for `user_id BETWEEN 41 AND 43 AND status = 'paid'`: `Handler_read_next` and `./lab.sh reads`; repeat with a wide range.
- **E11** — `(user_id, status, created_at)` vs `(user_id, created_at, status)` for an equality + range + `ORDER BY … DESC LIMIT 20` query, with a normal user and a 2,000-order user.
- **E12** — The range→ALL threshold for `total > X` on the lab, latency on both sides with and without `FORCE INDEX`; histogram on a non-indexed column and its effect on `filtered`.
- **E13** — Insert 1M rows into copies of `orders` with 0, 2, 5 and 8 secondary indexes; insert time and per-index size, compared with the size calculator on the index-write-cost page.
- **E14** — Change buffering `all` vs `none` with a 128MB buffer pool and indexes far larger than it: insert time, `Innodb_buffer_pool_reads`, `ibuf_merges`, and who pays for the merge.
- **E15** — Delete 60% of a 5M-row table: merge counters, `n_leaf_pages` and `.ibd` size before, after purge, after `OPTIMIZE TABLE`.
- **Q17–Q22** — The six recall questions in section 08 of the index-write-cost page.
- **E16** — Scan resistance: buffer-pool reads for a warmed point-query set after a full scan, `innodb_old_blocks_time` 1000 vs 0.
- **E17** — Commit throughput with `innodb_flush_log_at_trx_commit` 1, 2, 0 from 1 and 16 clients; `Innodb_os_log_fsyncs`.
- **E18** — A long open read view: history list length, undo size, read slowdown, purge catch-up time.
- **Q23–Q28** — The six recall questions in section 08 of the buffer-pool, redo and undo page.
- **E19** — Two-session timeline under RR and RC, plus `WITH CONSISTENT SNAPSHOT` and the lost-update variant.
- **E20** — Covering read on `idx_user_id` inside an old read view after concurrent updates: buffer-pool requests vs a fresh session.
- **Q29–Q34** — The six recall questions in section 08 of the MVCC page.
- **E21** — Lock map on a 3-row table: `data_locks` for 5 statements under RR and RC, and which of 4 inserts block.
- **E22** — Lost update reproduced and fixed two ways; crossed-transfer deadlock and its report; the same with ordered locking. *(The Month 1 Week 4 hands-on item.)*
- **E23** — Lock on the first entry past a range, secondary index vs PK, on 8.4.
- **Q35–Q40** — The six recall questions in section 08 of the locking page.
- **E24** — 50 concurrent withdrawals of 30 from 1,000 with each of the five strategies in the concurrency-control simulator: successes, final balance, invariant. *(The Month 3 "reproducible concurrency experiment" deliverable.)*
- **E25** — One hot row at 1, 8 and 32 clients for 30 s: tx/s, p50/p99, version retries, `Innodb_row_lock_waits`, with and without 5 ms of app work under the lock.
- **E26** — `affectedRows` and `changedRows` in mysql2 with and without `FOUND_ROWS`, for a no-op update, a refused withdrawal and a missing account.
- **Q41–Q46** — The six recall questions in section 08 of the concurrency-control page.
- **C1–C3** — The three real-world cases in section 09 of the concurrency-control page (flash sale stock and per-user limit, crossed-transfer deadlocks, long-lived edit form vs a batch job). Solve in writing before opening the answers.
- **E27** — 2 and 10 concurrent requests with one idempotency key: ledger rows, status codes, `data_locks` of the waiting requests, deadlock when the first rolls back.
- **E28** — Kill a consumer at three points for four marker designs; count how many times the effect happens. *(Month 3 deliverable: tests for duplicate processing and retries.)*
- **E29** — Retry storm against a rate-limited endpoint: immediate, exponential, full jitter, equal jitter. Checks the page's model against the AWS article.
- **Q47–Q52** — The six recall questions in section 08 of the idempotency page.
- **C4–C6** — The three real-world cases in section 09 of the idempotency page (payment gateway with out-of-order webhooks, SMS without provider idempotency, a retry storm after a 90 s database failover). Solve in writing before opening the answers.
- **E30** — 1,000 orders with each dual-write design and the outbox under injected crashes, broker rejects and commit failures; reconcile orders vs events.
- **E31** — The id-cursor gap by hand; then two `SKIP LOCKED` relays killed every 10 s: lost and duplicated events, `data_locks` on `idx_unsent`.
- **E32** — Polling relay latency (p50/p99) and idle query rate at 100 ms and 1 s sleep, 10 and 1,000 events/s.
- **Q53–Q58** — The six recall questions in section 08 of the outbox page.
- **Q11–Q16** — The six recall questions in section 08 of the composite-index page (answers are on the page, hidden).
- **Q1–Q5** — The five check questions at the end of the page (leftmost prefix, `COUNT(*)` and the visibility map, full scan polluting the cache, TOAST, a `sessions` table updated 5,000×/sec). Answer in writing before looking anything up, then verify.

---

## 2026-10-20 — Transactional outbox

**Topic and objective.** Month 3 topic, written ahead as documentation only (Phase 3 of the documentation plan): why writing to the database and the broker separately loses or invents events, how an outbox in the same transaction fixes it, how to relay the outbox without skipping rows, polling vs CDC, and sagas at concept level.

**Output.** [topics/transactional-outbox/index.html](../topics/transactional-outbox/index.html) — 10 sections. Widgets: a dual-write matrix that runs a small model for four designs × three failures (crash, broker reject, commit failure) and labels each cell matched / lost event / phantom event; an 8-step stepper of a relay with an id cursor skipping an event committed late, and the status-based fix; a polling calculator (sleep-then-drain cycle: added latency, idle query rate, keeps up or not); a saga stepper with a selectable failing step and reverse compensations. Prediction templates for E30–E32.

**What it covers.**

- Dual write and its two failure directions; no ordering or in-transaction send fixes it.
- Outbox row in the same transaction; relay at-least-once (send, then mark), so consumers dedup by `event_id`.
- Polling relay: AUTO_INCREMENT ids are assigned at insert and become visible at commit, so an id or time cursor can skip rows forever; read by status with an index on `(sent_at, id)`; several relays with `FOR UPDATE SKIP LOCKED`, ordering by aggregate key; batched cleanup; lock held while publishing.
- CDC: MySQL 8.4 binlog on by default, ROW format (variable deprecated); Debezium outbox router default columns, `outbox.event.<aggregatetype>` routing, DELETE events ignored, event id for dedup.
- Saga: local transactions plus compensations, no isolation, orchestration vs choreography; why not XA/2PC.

**Initial understanding.** TODO — what did I believe about publishing events from a service before this page? No prior belief was stated in the session.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: sending after commit is safe; sending inside the transaction lets rollback cancel the event; an id cursor is safe because ids increase; an outbox gives exactly-once to consumers; a compensation is a rollback.

**Experiments and results.** None. All widgets are models; the id-cursor gap is derived from how AUTO_INCREMENT and consistent reads work and has not been reproduced (E31).

**Competency level.** Level 2 provisional on three new matrix rows; Level 1 on sagas, which the page covers at concept level only.

**Remaining questions.** Open questions 25 and 26.

**Next step.** Topic 13 of the plan, BullMQ workers and resumable batches.

---

## 2026-10-20 — Idempotency and retries

**Topic and objective.** Month 3 topic, written ahead as documentation only (Phase 3 of the documentation plan): why retries are unavoidable and duplicates come with them, how to make the receiving side idempotent at the API and at a queue consumer, and how to retry without making an outage worse.

**Output.** [topics/idempotency-retries/index.html](../topics/idempotency-retries/index.html) — 10 sections. Widgets: a configurable stepper for one transfer over an unreliable network (four failure scenarios × retry on/off × idempotency key on/off, counting transfers); a 7-step stepper of two requests with the same key (INSERT, S-lock wait on the uncommitted duplicate, 1062, return the stored response; 422 and rollback variants); a dedup-placement matrix that runs a small model for four marker designs × three crash points; a retry-storm simulator (outage, fixed capacity, immediate / exponential / full jitter / equal jitter). Prediction templates for E27–E29.

**Cases added (same day).** Section 09 "Bài toán thực tế" with cases C4–C6, each a shown problem and a hidden senior-style answer. The answers are reasoning from reading, not measurements.

**What it covers.**

- At-most-once vs at-least-once; idempotent receiver gives effectively-once; naturally idempotent operations and RFC 9110 method semantics.
- Idempotency key: client-generated per operation, `(owner, key)` unique, fingerprint, stored response; key and effect in one transaction when the effect is in the same database, `processing` state plus recovery when it is external; pass the key downstream. IETF draft 07 (expired) codes 400 / 422 / 409; Stripe v1 behaviour (stored response including 500, ≥ 24 h, 255 chars).
- Consumer dedup: marker before (loses), after (duplicates), same transaction (correct); ack after commit; Redis `SET NX` as a separate-store marker.
- Backoff: exponential with cap, full and equal jitter, attempt limits, retry budget, retry amplification across layers; which errors to retry; DLQ and redrive. BullMQ backoff formula and `jobId` dedup read from the 6.3.17 source; SQS FIFO 5-minute dedup window.

**Initial understanding.** TODO — what did I believe about idempotency and retries before this page? No prior belief was stated in the session.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: an "exactly-once" queue removes the need for idempotent consumers; a timeout means the server did nothing; a new key per attempt; write the marker first to be safe; exponential backoff alone is enough; retry every error.

**Experiments and results.** None. All four widgets are models. One discrepancy is already visible inside the model: equal jitter needs fewer calls than full jitter in the page's outage-then-fixed-capacity model, while the AWS article found full jitter cheapest in its own model; E29 is meant to settle it on a real endpoint.

**Competency level.** Level 2 provisional on four new matrix rows.

**Remaining questions.** Open questions 23 and 24.

**Next step.** Topic 12 of the plan, transactional outbox.

---

## 2026-10-20 — Concurrency control strategies on a balance

**Topic and objective.** Month 3 topic, written ahead as documentation only (Phase 3 of the documentation plan): why read-check-write loses money or overdraws even inside a transaction, the three ways to hold `balance ≥ 0` under concurrent withdrawals, what each costs, and where all three stop working (a hot row).

**Output.** [topics/concurrency-control-strategies/index.html](../topics/concurrency-control-strategies/index.html) — 10 sections. Widgets: a race simulator (N requests, five strategies, seeded interleaving, lock queue, per-tick timeline with lock-hold bars, invariant check); a 6-step conditional-UPDATE stepper showing the second request re-evaluate `WHERE` on the latest committed version and get 0 rows; a hot-row calculator (lock hold time, max tx/s, M/D/1 wait) comparing `FOR UPDATE` with a conditional UPDATE; a 6-step version-column stepper. Prediction templates for E24–E26.

**Cases added (same day).** Section 09 "Bài toán thực tế" with cases C1–C3, each a shown problem and a hidden answer reasoned as a senior would (clarify, estimate, options with pros and cons, decision, implementation, risks and verification, common mistakes). The answers are reasoning from reading, not measurements. The same commit adds section 9 to the shared page structure in `content.md`, the `.case` component to `style.md`, and the section to `SKILL.md` and `CLAUDE.md`; pages written before 2026-10-20 still have ten sections.

**What it covers.**

- Lost update (read, compute, overwrite) and check-then-act (read, check, `balance = balance - x`); plain `SELECT` takes no lock under RR, and InnoDB raises no error when the later writer overwrites.
- Conditional `UPDATE … WHERE balance >= ?`: locking read of the latest committed version, wait, re-evaluation; result read from affected rows. Affected rows means changed rows by default and matched rows with `CLIENT_FOUND_ROWS` (C API manual); mysql2 sets `FOUND_ROWS` by default (checked in `lib/connection_config.js`, mysql2 3.24.6), so `affectedRows` is matched and `changedRows` is changed.
- `SELECT … FOR UPDATE`: reads the latest version, holds the X lock to the end of the transaction, needs an explicit transaction on one connection (autocommit releases it at once; a pool may spread statements over connections). Hold time as the ceiling on one row's throughput.
- Version column: optimistic check in the same `UPDATE`, retry with jittered backoff, good for long think time and low contention, bad under high contention.
- Hot rows: append-only ledger, split balances, batching, and what each gives up.
- SERIALIZABLE on InnoDB turns the race into deadlocks; PostgreSQL RR raises a serialization error (40001) where InnoDB RR overwrites. `CHECK (balance >= 0)` as a safety net (catches overdraw, not lost update).

**Initial understanding.** TODO — what did I believe about concurrent balance updates before this page? No prior belief was stated in the session.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: a transaction makes read-then-write safe; `balance = balance - x` alone is safe; `FOR UPDATE` holds its lock under autocommit or across pool calls; `affectedRows` always counts changed rows; optimistic is always faster; SERIALIZABLE fixes it.

**Experiments and results.** None. The simulator and the calculator are models built from the manual; nothing was run against MySQL. E24–E26 are the measurements; E24 is the Month 3 concurrency-experiment deliverable.

**Competency level.** Level 2 provisional on four new matrix rows.

**Remaining questions.** Open questions 21 and 22.

**Next step.** Topic 11 of the plan, idempotency and retries.

---

## 2026-10-19 — Locking and deadlocks (InnoDB)

**Topic and objective.** Month 1 Week 4 topic, written ahead as documentation only: what InnoDB locks for each kind of statement, why a missing index can lock a whole table, lost update and its fixes, and how deadlocks are detected and handled. Closes Phase 1 of the documentation plan.

**Output.** [topics/innodb-locking-deadlock/index.html](../topics/innodb-locking-deadlock/index.html) — 10 sections. Widgets: a lock map over PRIMARY and `idx_age` for 5 statements under RR and RC, listing the locks in `data_locks` form and letting 4 INSERT probes show whether they block and which lock blocks them; a 7-step crossed-transfer deadlock with the wait-for edges. A comparison table of four lost-update fixes. Prediction templates for E21–E23.

**What it covers.**

- Lock types from the 8.4 manual: S/X, IS/IX, record, gap (inhibit inserts only, never conflict with each other), next-key, insert intention, AUTO-INC.
- Locking reads, `UPDATE`, `DELETE` lock every index entry scanned, not only matching rows; no usable index means every row and gap; a unique search for one row takes a record lock only; locking through a secondary index also locks the PRIMARY record. `INSERT` takes a record lock after an insert-intention lock; duplicate key takes an S lock (the manual's three-session deadlock).
- READ COMMITTED drops gap locks except for FK and duplicate-key checks, and releases locks on non-matching rows.
- Lost update fixes: atomic statement, `FOR UPDATE`, version column, SERIALIZABLE.
- Deadlock detection on wait, small-transaction victim, 1213 rolls back the transaction, 1205 rolls back only the statement by default; lock ordering; `SKIP LOCKED` for job queues.
- Comparison with PostgreSQL (row locks in tuples, no gap locks, SSI, `deadlock_timeout`).

**Initial understanding.** TODO — what did I believe about InnoDB locking before this page? No prior belief was stated in the session.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: InnoDB locks rows; `UPDATE … WHERE` locks only matching rows; locking a missing key locks nothing; gap locks conflict with each other; 1205 rolls back the transaction; deadlocks must be eliminated entirely.

**Experiments and results.** None. The lock map is derived from the manual and has not been compared with `data_locks` on the lab. E21–E23 are the measurements; E22 is the Week 4 hands-on item.

**Competency level.** Level 2 provisional on three new matrix rows.

**Remaining questions.** Open questions 19 and 20.

**Next step.** Phase 1 documentation is complete (index write cost, buffer pool/redo/undo, MVCC, locking). The lab phase follows: script E13–E23 into `lab.sh`, write predictions, run them in Weeks 3–4 alongside E8, E9–E12 and the baseline assessment.

---

## 2026-10-19 — MVCC and read views (InnoDB)

**Topic and objective.** Month 1 Week 4 topic, written ahead as documentation only: how InnoDB decides which version of a row a plain `SELECT` sees, when the snapshot is taken under each isolation level, and why `SELECT`, locking reads and `UPDATE` in the same transaction can see different data.

**Output.** [topics/mvcc-read-view/index.html](../topics/mvcc-read-view/index.html) — 10 sections. Widgets: a two-session timeline (10 steps) switchable between REPEATABLE READ and READ COMMITTED, showing what each statement returns; a visibility playground where `low_limit_id`, the active list and the creator are chosen and the version chain is walked with the rule applied to each version. Prediction templates for E19–E20.

**What it covers.**

- Hidden columns `DB_TRX_ID` (6 bytes) and `DB_ROLL_PTR` (7 bytes), the version chain through undo; insert undo dropped at commit, update undo kept for consistent reads. Transaction IDs are assigned on first write.
- Read view: creator, `low_limit_id`, `m_ids`, `up_limit_id`, and the visibility rule (checked against `ReadView::changes_visible` in `storage/innobase/include/read0types.h` on the 8.4 branch).
- RR takes the snapshot at the first consistent read (not at `START TRANSACTION`; `WITH CONSISTENT SNAPSHOT` takes it immediately); RC per statement; RU none; SERIALIZABLE turns plain `SELECT` into `FOR SHARE` when autocommit is off.
- Locking reads and DML read the latest committed version; the manual's `COUNT = 0` then `UPDATE` affects 10 rows example; lost update with application-side read-modify-write, and three fixes.
- Secondary-index entries have no hidden columns; delete-marked entries or pages modified by newer transactions force a PRIMARY lookup, disabling the covering-index shortcut.
- Anomaly table per isolation level for InnoDB; comparison with PostgreSQL (RR raises a serialization error on concurrent update, SSI for SERIALIZABLE).

**Initial understanding.** TODO — what did I believe about MVCC and isolation before this page? No prior belief was stated in the session.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: snapshot at `START TRANSACTION`; every statement in an RR transaction sees the same data; RR prevents lost update; read views compare commit times; MySQL and PostgreSQL RR behave the same; covering indexes never touch PRIMARY.

**Experiments and results.** None. The two-session results are derived from the manual. E19 and E20 are the measurements.

**Competency level.** Level 2 provisional on four new matrix rows.

**Remaining questions.** Open questions 18 and 19.

**Next step.** Locking and deadlocks, which finishes the Week 4 topic list (record, gap, next-key locks; lost update and deadlock by hand).

---

## 2026-10-19 — Buffer pool, redo log and undo log (InnoDB)

**Topic and objective.** Month 1 Weeks 3–4 groundwork, written ahead as documentation only: what InnoDB does between `UPDATE` and the page reaching disk, at the level needed to explain behaviour. Buffer pool and midpoint LRU, dirty pages and checkpoints, redo log and durability settings, doublewrite, undo log and purge, crash recovery order.

**Output.** [topics/innodb-buffer-pool-redo-undo/index.html](../topics/innodb-buffer-pool-redo-undo/index.html) — 10 sections. Widgets: a 10-step trace of `UPDATE … ; COMMIT` with checkpoint, flushed and current LSN (values invented for consistency, labelled); an 8-frame midpoint-LRU simulator with `innodb_old_blocks_time` 1000 vs 0 against a table scan; a checkpoint-age calculator (linear model, labelled); a crash-loss matrix for `innodb_flush_log_at_trx_commit` 1/2/0 vs mysqld crash and power loss; a 6-step crash-recovery stepper. Prediction templates for E16–E18.

**What it covers.**

- Steal / no-force: commit only writes and fsyncs redo; page cleaner writes pages later, in first-modification LSN order; the WAL rule (page LSN ≤ flushed LSN before a page write).
- Midpoint LRU from the 8.4 manual: old sublist 3/8 (`innodb_old_blocks_pct = 37`), new pages enter at its head, made young only when accessed again after `innodb_old_blocks_time` (1000 ms).
- Redo on 8.4: `innodb_redo_log_capacity` (100MB default), 32 files in `#innodb_redo`, `Innodb_redo_log_checkpoint_lsn` / `current_lsn` / `flushed_to_disk_lsn`; checkpoint age and write stalls near the limit.
- `innodb_flush_log_at_trx_commit`: 1 loses nothing; 2 loses up to about a second only on OS crash or power loss; 0 loses up to about a second even on a mysqld crash. Group commit. `sync_binlog` when the binlog is on.
- Doublewrite against torn pages; undo records, `DB_TRX_ID`, `DB_ROLL_PTR`, purge, history list length, and why a long read-only transaction blocks purge for every table.
- Recovery: doublewrite check, redo from checkpoint (regardless of commit state), then rollback of active transactions in the background.
- Comparison with PostgreSQL (WAL, no undo, full-page writes, clock-sweep).

**Initial understanding.** TODO — what did I believe about redo, undo and the buffer pool before this page? No prior belief was stated in the session. The competency matrix had WAL ordering at Level 1 from the PostgreSQL-shaped 2026-10-14 page.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: commit writes the table file; a 99% hit rate means enough memory; a scan always wipes the cache; value 2 loses data on a mysqld crash; read-only transactions are harmless; redo alone can repair a torn page.

**Experiments and results.** None. The LSN trace, the LRU simulator and the checkpoint calculator are models. E16–E18 are the measurements.

**Competency level.** Level 2 provisional on four new matrix rows. The 2026-10-14 rows on buffer pool and WAL stay as they are; these rows are the InnoDB counterparts.

**Remaining questions.** Open questions 15–17.

**Next step.** MVCC and read views, which the undo section points to.

---

## 2026-10-19 — Index write cost (InnoDB)

**Topic and objective.** Month 1 Week 3 topic, written ahead as documentation only (labs come later): what each index costs on the write path. Which trees an `INSERT`, `UPDATE` or `DELETE` touches and how; page split and page fill under sequential vs random keys; page merge; the change buffer and its 8.4 default; PK choice (BIGINT, UUIDv4 as text or binary, UUIDv7) and its effect on every secondary index.

**Output.** [topics/index-write-cost/index.html](../topics/index-write-cost/index.html) — an interactive page in the fixed 10-section structure. Widgets: a statement-by-index-set explorer (7 statements × 0/2/5/8 secondary indexes, showing for each tree whether it gets an insert, an in-place update or a delete-mark plus insert), a leaf-split simulator with 8-key pages in three key orders (ascending, near-ascending UUIDv7, random UUIDv4), a 7-step change-buffer stepper (off vs on, merge on read), and a size calculator by PK type and index count. Prediction templates for E13–E15 under `lab/mysql/experiments/`.

**What it covers.**

- Every `INSERT` adds one entry to every tree. An `UPDATE` rewrites PRIMARY in place when the row does not grow, and touches a secondary index only when one of its columns changes; then it delete-marks the old entry and inserts a new one. Changing the PK rewrites every secondary index. `DELETE` delete-marks everywhere; purge removes later.
- Unique indexes (PRIMARY included) must read the leaf to check for duplicates before inserting, so they can never defer the read.
- The 8.4 manual: sequential inserts leave pages about 15/16 full, random inserts 1/2 to 15/16; 1/16 is reserved for updates. Each secondary index has its own insert order, so an AUTO_INCREMENT PK does not make `idx_user_id` sequential.
- `MERGE_THRESHOLD` (default 50) and merge-split churn; freed pages return to the tablespace, not to the OS.
- Change buffer: defers insert, delete-mark and purge on non-unique secondary leaves that are not in the buffer pool; merged on read, in the background and at slow shutdown. **8.4 changed the default of `innodb_change_buffering` from `all` to `none`.**
- PK choice: bytes copied into every secondary entry and insert order into PRIMARY. MySQL has no UUIDv7 function; `UUID_TO_BIN(UUID(), 1)` makes v1 time-ordered.
- Comparison with PostgreSQL's heap and with LSM trees.

**Initial understanding.** TODO — what did I believe about index write cost before this page? No prior belief was stated; the page was requested as part of building Phase 1 documentation ahead of the labs.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: counting bytes changed instead of indexes containing the changed column; assuming a sequential PK makes every index sequential; assuming the change buffer still hides secondary-index reads on 8.4; expecting a large delete to shrink the file.

**Experiments and results.** None. The split simulator and the size calculator are models built from the manual, labelled as such on the page. E8 (already scripted), E13, E14 and E15 are what would turn them into measurements.

**Competency level.** Level 2 provisional on four new matrix rows. Nothing above 2 until E8 and E13–E15 run.

**Remaining questions.** Open questions 4 (partly answered), 12, 13 and 14.

**Next step.** Continue Phase 1 documentation: buffer pool, redo and undo, which the write-cost page leans on for "dirty page" and "redo". In the lab phase: script E13–E15 in `lab.sh` and run them together with E8 in Week 3.

---

## 2026-10-19 — Composite index and query plans (MySQL)

**Topic and objective.** Month 1 Week 2 topic, started early: how MySQL uses a multi-column index and how to read the plan it chose. Leftmost prefix and why a range on a middle column stops the later columns from narrowing the scan; column order (equality, sort, range) and when `ORDER BY` avoids filesort; Index Condition Pushdown and `Using index condition` vs `Using where`; cardinality, index dives and histograms, and why the optimizer skips a good index; reading `EXPLAIN` and `EXPLAIN ANALYZE`.

**Output.** [topics/composite-index-query-plan/index.html](../topics/composite-index-query-plan/index.html) — an interactive page in 7 sections. The hero is a query builder over the real index entries of three users: pick conditions, `SELECT` list, `ORDER BY` and any of the 6 column orders, and it computes the seek intervals, which entries are read, which are rejected inside the index, which rows are looked up through PRIMARY, the resulting `EXPLAIN` fields and whether a filesort is needed. Also: a 10-step range trace (`user_id BETWEEN 41 AND 43 AND status = 'paid'` vs `IN (41, 42, 43)`), a table comparing all 6 column orders for 4 queries, an ICP on/off flow, a chart of estimated vs actual rows around the point where the optimizer drops `idx_total`, and a clickable annotated `EXPLAIN` row.

**What it covers.**

- An InnoDB secondary index on `(user_id, status, created_at)` is really sorted by `(user_id, status, created_at, id)`. Seeking needs a leftmost prefix; the prefix stops at the first column with no condition, and after the first range column no later column narrows the scan, though equality columns after it still appear in the interval end points.
- `key_len` counts the bytes of every column in the interval end points, so `BETWEEN 41 AND 43 AND status = 'paid'` shows `key_len = 5` while `EXPLAIN FORMAT=JSON` reports `used_key_parts: ["user_id"]`. `IN` is a set of point seeks, so rewriting the range as `IN (41, 42, 43)` lets `status` narrow every interval.
- `ORDER BY c` comes from the index only when every column before `c` is fixed to a single value; `IN` or a range before it forces filesort. `DESC` gives `Backward index scan`; mixed directions need a descending index (8.0).
- ICP filters on index entries inside InnoDB before the PRIMARY lookup; `Using where` is the server filtering rows afterwards. ICP applies only to secondary indexes and never with a covering index.
- Estimates come from index dives (falling back to cardinality from `eq_range_index_dive_limit` = 200 values), sampled cardinality (20 pages), and manually built histograms that fix `filtered` for non-indexed columns. A table of common reasons a good index is skipped: too many estimated rows, function on the column, implicit cast, stale statistics, long `IN` lists, `ORDER BY … LIMIT`, collation mismatch in joins.
- `EXPLAIN` columns and the `type` ladder; `rows` is rows read by that access, not rows returned; `EXPLAIN ANALYZE` reports estimates next to actual time (first..last row, per loop), rows per loop and loops.

**Initial understanding.** TODO — what did I believe about composite indexes and `EXPLAIN` before this session? The baseline self-score was 2 for composite index and "basic" for `EXPLAIN`; the session started from the topic list only, with no stated prior belief.

**Mistakes and misconceptions corrected.** TODO — only I know which. Traps the page writes down: reading `key_len` as the number of columns used to seek; reading `Using index condition` as "the index is used well"; reading `rows` as rows returned; expecting `ORDER BY created_at` to be free on `(user_id, status, created_at)` with only `user_id` fixed.

**Experiments and results.** None by me. To make the page accurate, Claude ran MySQL 8.0.46 in its own sandbox on a 1M-row `orders` table built with the lab's generator (`users = 100000`) plus `idx_usc (user_id, status, created_at)`, and the page quotes those outputs, each labelled as sandbox output: `EXPLAIN` / `FORMAT=JSON` / `EXPLAIN ANALYZE` lines, `Handler_read_next` 18 with ICP and 23 without, the `total > X` range→ALL threshold, and `filtered` before and after histograms. Several observations were surprising enough to become open questions 8–10 and the redundancy note in §01 (the optimizer chose `idx_user_id` + `Using where` over the composite index with ICP). It was the wrong version on the wrong machine, nothing was predicted beforehand, and none of it is evidence for my competency level; E9–E12 on the 8.4 lab are.

**Competency level.** Level 2 provisional on the five new matrix rows. Nothing above 2 until E9–E12 run.

**Remaining questions.** Open questions 8–10 above.

**Next step.** After E6 from the Week 1 lab: add `idx_usc` to the 5M lab table, write predictions for E9 and E10, run them. Bring a real slow query from work for the Month 1 index-design case study; this page is the toolkit for it.

*Later the same day:* the page was restructured into the fixed document structure now required for every topic (see `.claude/skills/topic-page/references/content.md`): goals, prerequisites and status in the hero; then core concept, mechanism, design reasons, examples, experiments, production implications, misconceptions, recall questions with hidden answers, open questions, references with a verification table. Reading the 8.4 manual for the references section partly answered open question 8 and raised open question 11. Prediction templates for E9–E12 were added under `lab/mysql/experiments/`.

---

## 2026-10-19 — MySQL lab setup

**Topic and objective.** Build the Month 1 Week 1 lab: MySQL 8.4 in Docker with a fixed configuration, a data generator for 5–10M rows, and a repeatable way to measure page reads, query latency and insert throughput, so E5, E6 and E8 can run as real experiments instead of models.

**Output.** [lab/mysql](../lab/mysql/README.md): `compose.yaml` (MySQL 8.4, port 3307), `conf/lab.cnf`, `sql/schema.sql` (tables `orders`, `orders_uuid`, `e8_*`, a deterministic generator procedure and a `uuid_v4()` function), and `lab.sh` with `up`, `load`, `sizes`, `cold`, `pages`, `reads`, `latency`, `e5`, `e6`, `e8`. Each experiment has a `prediction.md` with the questions; `lab.sh` refuses to run it while the file still says `TODO`, so the prediction is written before any result exists (TECHNICAL_GROWTH.md Principle 2 and the rules for AI use during learning).

**What it covers.**

- Configuration chosen so each measurement means what it claims: buffer pool fixed at 1 GB, no buffer-pool dump or load across restarts (so a restart is truly cold), `O_DIRECT` (no OS page cache behind the buffer pool), adaptive hash index off, binary log off, `module_index` metrics on for page-split counts.
- Measurement method. `Innodb_buffer_pool_read_requests` and `Innodb_buffer_pool_reads` are server-wide, so `reads` waits for the server to go quiet and reports a `DO 0` window next to each run as a noise check. `Handler_read_*` are per session, so the cost of the measuring statements is subtracted. `INFORMATION_SCHEMA.INNODB_BUFFER_PAGE` lists which pages of the table entered the buffer pool, per index and page type. Latency comes from `events_statements_summary_by_digest` (avg, histogram-based p95/p99).
- Two measurement traps found while testing the scripts, both fixed in `lab.sh`: right after a restart, background threads and the first read of each performance_schema table (its definition comes from the InnoDB data dictionary) add page accesses to the same global counters; and the first query on a table after a restart also pays for loading the table definition, which a `SELECT … LIMIT 0` absorbs without reading any of the table's pages.

**Initial understanding.** TODO — what did I expect the lab to need, and what did I not know how to measure before?

**Mistakes and misconceptions corrected.** TODO — only I know which.

**Experiments and results.** None that count as evidence. The scripts were smoke-tested by Claude in its own sandbox on MySQL 8.0.46 from Ubuntu's packages, because Docker Hub is not reachable there. That run proved the scripts work end to end (5M-row load, `reads`, `latency`, E5 and E8 at small sizes). It was the wrong version on the wrong machine, its results were deliberately not committed so they cannot leak into the predictions, and no prediction had been written. The Docker path itself (`./lab.sh up` with MySQL 8.4) is untested until I run it.

**Competency level.** Unchanged. Building measurement scripts is not evidence for the Track A topics; running the experiments is.

**Remaining questions.** Open question 1 is now practically answered by the lab being MySQL-first; confirm it as a decision.

**Next step.** On my machine: `cd lab/mysql && ./lab.sh up && ./lab.sh load orders 5000000`. Then write `experiments/e6/prediction.md` and run `./lab.sh e6`. Also still due this week: the baseline assessment (TECHNICAL_GROWTH.md Section 11).

---

## 2026-10-19 — Clustered vs secondary index

**Topic and objective.** What a clustered index is and how it differs from a secondary index, InnoDB first with PostgreSQL as the comparison: what each leaf holds, what a lookup through a secondary index costs, which trees an `UPDATE` writes, and why InnoDB points from secondary indexes to the PK instead of to a physical address.

**Output.** [topics/clustered-vs-secondary-index/index.html](../topics/clustered-vs-secondary-index/index.html) — an interactive page in 6 sections: an entry-to-row explorer (both engines), a leaf-entry size calculator, an 11-step page-by-page trace of `SELECT * … WHERE user_id = 42`, an UPDATE matrix (which trees get written, HOT on and off), and a 6-step clustered-index leaf split. The lesson and the first draft were done on 2026-10-14 as a chat explanation plus a standalone visualisation; it was converted to a topic page and committed on 2026-10-19.

**What it covers.**

- A clustered index is the index whose leaves hold the whole row; a table has at most one. InnoDB always has one (PK, else the first `NOT NULL` unique index, else a hidden 6-byte `DB_ROW_ID`). PostgreSQL has none: rows live in an unordered heap and every index, PK included, stores key + TID. `CLUSTER` sorts the heap once, is not maintained, and takes `ACCESS EXCLUSIVE`.
- InnoDB secondary leaves hold the PK value, so the real key of `(user_id)` is `(user_id, id)`: `SELECT id` is covering for free and `ORDER BY id` after `WHERE user_id = ?` needs no sort. The PK is copied into every secondary index, so a `CHAR(36)` PK roughly triples each one compared with `BIGINT`.
- Lookup cost: InnoDB walks the PRIMARY tree once per row; PostgreSQL reads one heap page per row. In the modelled trace both engines do 5 disk reads; InnoDB's 6 extra page accesses are buffer-pool hits on PRIMARY's root and internal pages.
- Writes: InnoDB rewrites only the indexes whose columns changed (or all of them when the PK changes). PostgreSQL adds an entry to every index whenever the row gets a new TID; HOT avoids that only when no indexed column changed and the heap page has room.
- Why InnoDB points by PK: a leaf split in PRIMARY moves rows between pages without touching any secondary index. The price is the extra tree walk on every read. PostgreSQL's heap never splits; its equivalent cost is the non-HOT update.
- SQL Server, Oracle (IOT) and SQLite (`rowid`, `WITHOUT ROWID`) placed on the same axis.

**Initial understanding.** TODO — what did I believe about clustered vs secondary indexes before this session? The session started from the single request "explain clustered index vs secondary index in detail", with no stated prior belief.

**Mistakes and misconceptions corrected.** TODO — only I know which. Candidates the page writes as traps: assuming an InnoDB secondary index points straight at the row; equating "clustered index" with "primary key" (true only for InnoDB and SQL Server's default).

**Experiments and results.** None. The trace counts, the calculator's sizes and the UPDATE matrix are a model built from reading, not observations. E5–E8 below are what would turn them into numbers.

**Competency level.** See the matrix: Level 2 provisional on the four rows this session touched, including InnoDB specifics (up from 1). Nothing here supports Level 3 until E5–E8 run on MySQL 8.4.

**Remaining questions.** Open questions 1, 6 and 7 above.

**Next step.** Week 1 lab setup (MySQL 8.4 in Docker, a 5–10M-row generator), then run E6 first: it is the cheapest check of this session's central claim, that the extra PRIMARY walk costs hits rather than disk reads.

---

## 2026-10-14 — B+tree index internals

**Topic and objective.** How a B+tree index works from the query down to individual pages in RAM: structure, growth, page layout, caching, and the cost model that makes a query fast or slow.

**Output.** [topics/btree-index-internals/index.html](../topics/btree-index-internals/index.html) — an interactive page in 10 sections with four working simulations (B+tree playground with live splits, index size/height calculator, 4-frame clock-sweep buffer pool, covering-index page-count comparison). Committed as `Add interactive B+tree index internals topic`.

**What it covers.**

- Where B+trees are used, and where they are the wrong tool (hash, GIN, GiST, BRIN, LSM). When an index helps: equality, range, `ORDER BY`, `MIN`/`MAX`, prefix `LIKE`, leftmost prefix of a composite. When it does not: leading wildcard, a function wrapping the column, low cardinality, or a query returning most of the table.
- Pages as the unit of storage; per-database page sizes; usable space after header and per-entry overhead; fan-out driving tree height — ~400 entries/page with a bigint key means 3 levels covers ~64M rows, so a point lookup in hundreds of millions of rows costs 3–4 page reads.
- Split: new page, move about half the entries, push a separator up; leaf split copies the key up, internal split moves it; a split reaching the root adds a level. The tree grows from the top, all leaves stay at the same depth. Rightmost splits for ascending keys stay near-full; random keys (UUIDv4) leave leaves 50–70% full and bloat the index.
- Slotted page: a sorted line-pointer array growing from the front, tuples appended from the back, so an insert in the middle never shifts data. Same layout on disk and in RAM. Page header carries the LSN.
- Buffer pool: frames, hash table, descriptors (pin count, dirty, usage count, latch). Pages load lazily; child pointers are page numbers, so every level costs a buffer-pool lookup. Upper levels are ~1% of the index and effectively never evicted — what decides speed is whether the *leaves* are resident. Pin vs latch vs lock separated by what they protect and for how long. PostgreSQL clock-sweep vs InnoDB young/old LRU.
- Write path: WAL before data page; commit only needs the WAL fsync; data pages stay dirty until the background writer, a checkpoint, or eviction.
- A 24-page trace of a realistic query, where only 5 accesses are index pages and the rest are scattered heap fetches — the heap fetch is the expensive part.
- Index Only Scan and why one extra column kills it; `INCLUDE` columns; the MVCC catch (the index carries no visibility info, so a high `Heap Fetches` means run `VACUUM`, not redesign the index). Cost is per *row*, not per column — the jump is 0 → 1 heap fetch per row — with TOAST as the exception. Covering indexes cost write amplification and break HOT updates.
- Heap, `ctid`, `xmin`/`xmax`, and the fact that `UPDATE` never overwrites in place; bloat, long-running transactions blocking `VACUUM`, `fillfactor`.

**Initial understanding.** TODO — what did I believe before this session? Baseline (TECHNICAL_GROWTH.md Section 1) self-scored composite index at 2 and `EXPLAIN` at basic level, with locking/MVCC "studied but forgotten". Worth writing down which parts of the above were actually new.

**Mistakes and misconceptions corrected.** TODO — only I know which. Candidates visible in the page, written as traps, so probably ones I hit: separator key must be updated in the parent after a split (otherwise lookups walk to the wrong leaf); line pointers are ordered by key while the addresses they point to are not; a PostgreSQL leaf entry holds only key + TID and does *not* implicitly contain the PK, so `SELECT id, total` needs `INCLUDE (total, id)`; `read` in `BUFFERS` means "not in shared_buffers", not "hit the disk".

**Experiments and results.** None. Nothing on this topic has been measured — the four simulations are models I built from reading, not observations. This is the single biggest weakness of the session, and the reason every level above is provisional.

**Competency level.** See the matrix. Level 2 provisional across the mechanism topics; Level 1 on WAL and on InnoDB specifics.

**Remaining questions.** Open questions 1–5 above.

**Next step.** Run E2 first — it is the one exercise that is already on the Month 1 Week 3 plan, and the sequential-vs-random key result is the fastest way to turn split theory into a number. Before that, settle Open question 1, because it decides whether E1–E4 run on PostgreSQL or MySQL.
