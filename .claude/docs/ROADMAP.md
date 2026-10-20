# Six-Month Roadmap — Backend Engineer

> Version 3 — updated 2026-10-14. Extracted from `TECHNICAL_GROWTH.md` v2; progress marking added in v2; practice project removed in v3.
>
> This file is the schedule: what to work on, in which month, and what counts as done.
> The goals, principles, curriculum tracks, and mentoring rules behind it live in
> [TECHNICAL_GROWTH.md](TECHNICAL_GROWTH.md). Track letters (A–G) refer to Section 4 of that document;
> competency levels (0–4) refer to Section 8. Evidence for every mark here lives in
> [LEARNING_LOG.md](LEARNING_LOG.md).

Treat this as a provisional roadmap. Month 1 is planned week by week; later months are refined at each monthly checkpoint based on evidence.

## Progress marking

This file is not read-only. It is marked as work happens, and it is the only place that states how far along the program is.

Status values, for months and for individual items:

| Mark | Meaning |
|---|---|
| `[ ]` | Not started. |
| `[~]` | In progress. |
| `[x]` | Done **and** backed by a dated entry in [LEARNING_LOG.md](LEARNING_LOG.md). |
| `[!]` | Blocked or deliberately deferred — the reason is written inline. |

Rules for marking:

1. **`[x]` requires evidence.** A deliverable is done when the artifact exists and a log entry links to it. Reading about a topic, or writing notes about it, does not close a deliverable that asks for a measurement.
2. **Mark in the same session as the work.** A roadmap that is updated in a batch at the end of the month is a retrospective, not a plan.
3. **Dates stay honest.** When a week slips, change the dates in the schedule table rather than compressing the work. `[!]` with a one-line reason beats a silent `[x]`.
4. **Exit criteria are not deliverables.** Every deliverable can be `[x]` while the exit criterion is still `[ ]`; that is the normal state and the signal to stay in the month.
5. **Unplanned work gets recorded too.** Research done outside the plan goes in Unplanned work below, so the log and the roadmap do not disagree about what happened.

## Schedule

Program runs Monday 2026-10-19 → 2027-04-18: 26 weeks, 182 days.

Dates are ISO and are parsed by `.claude/scripts/progress.py`. Months must stay contiguous
(each month starts the day after the previous one ends) and week counts must match
the day span. When something slips, edit the dates here — the checker compares them
against today and against [LEARNING_LOG.md](LEARNING_LOG.md).

| Month | Start | End | Weeks | Primary focus | Status |
|---|---|---|---|---|---|
| 1 | 2026-10-19 | 2026-11-15 | 4 | Database internals and query optimization | `[~]` |
| 2 | 2026-11-16 | 2026-12-13 | 4 | Backend architecture and testing | `[ ]` |
| 3 | 2026-12-14 | 2027-01-10 | 4 | Transactions, concurrency, reliable async processing | `[ ]` |
| 4 | 2027-01-11 | 2027-02-14 | 5 | Production readiness, performance, observability (includes 1 buffer week for Tết) | `[ ]` |
| 5 | 2027-02-15 | 2027-03-14 | 4 | System design and trade-offs | `[ ]` |
| 6 | 2027-03-15 | 2027-04-18 | 5 | Capstone, interview readiness, final assessment | `[ ]` |

Do not advance simply because a month has ended. Each month has exit criteria; if I cannot meet them, revisit the gap before moving forward and shift the schedule.

## Unplanned work

Research and topics done outside the monthly plan. Each row needs a log entry, and should say which month it feeds.

| Date | Work | Artifact | Feeds | Log entry |
|---|---|---|---|---|
| 2026-10-14 | B+tree index internals (structure, split, slotted page, buffer pool, covering index, heap/MVCC) — conceptual only, no measurements; PostgreSQL-shaped, see open question 1 | [topics/btree-index-internals](../topics/btree-index-internals/index.html) | Month 1, Weeks 1–2 | [2026-10-14](LEARNING_LOG.md) |
| 2026-10-20 | Concurrency control strategies on a balance (conditional UPDATE, `FOR UPDATE`, version column, hot rows) — documentation only, written ahead of Month 3; no measurements | [topics/concurrency-control-strategies](../topics/concurrency-control-strategies/index.html) | Month 3 | [2026-10-20](LEARNING_LOG.md) |
| 2026-10-20 | Idempotency and retries (delivery semantics, idempotency keys, consumer dedup, backoff with jitter, DLQ) — documentation only, written ahead of Month 3; no measurements | [topics/idempotency-retries](../topics/idempotency-retries/index.html) | Month 3 | [2026-10-20](LEARNING_LOG.md) |
| 2026-10-20 | Transactional outbox (dual write, polling relay and the id-cursor gap, CDC from the binlog, saga at concept level) — documentation only, written ahead of Month 3; no measurements | [topics/transactional-outbox](../topics/transactional-outbox/index.html) | Month 3 | [2026-10-20](LEARNING_LOG.md) |
| 2026-10-20 | BullMQ workers and resumable batches (job lifecycle, locks and stalled jobs, checkpoints, worker operations) — documentation only, written ahead of Month 3; no measurements | [topics/bullmq-workers-resumable](../topics/bullmq-workers-resumable/index.html) | Month 3 | [2026-10-20](LEARNING_LOG.md) |

## Month 1 — Database Internals and Query Optimization

**Status:** `[~]`

Focus:
- InnoDB storage and B+ tree behavior.
- Clustered versus secondary indexes.
- Composite indexes and query plans.
- Index read/write trade-offs.
- Transactions and isolation fundamentals.

Weekly plan — each week carries its planned dates; edit them when the week slips:
- `[~]` **Week 1** `2026-10-19 → 2026-10-25` — **Baseline and lab setup**: database baseline assessment (TECHNICAL_GROWTH.md Section 11); MySQL 8.4 in Docker with performance_schema and sys schema enabled; a data generator for 5–10M rows; a repeatable way to measure query latency and insert throughput. Topic: InnoDB pages, B+ tree structure, clustered index.
- `[~]` **Week 2** `2026-10-26 → 2026-11-01` — **Reads**: secondary index lookups and the extra clustered-index lookup, composite indexes and leftmost prefix, covering indexes, range conditions, cardinality and histograms, EXPLAIN and EXPLAIN ANALYZE.
- `[~]` **Week 3** `2026-11-02 → 2026-11-08` — **Writes**: index maintenance on insert/update/delete, page splits, change buffer, sequential vs random primary keys (auto-increment vs UUIDv4 vs UUIDv7), measuring insert throughput and storage with 0, 2, 5, and 8 secondary indexes.
- `[~]` **Week 4** `2026-11-09 → 2026-11-15` — **Transactions**: MVCC and read views, isolation levels with REPEATABLE READ as default, consistent vs locking reads, record/gap/next-key locks, reproducing a lost update and a deadlock by hand. Monthly checkpoint.

Deliverables:
- `[~]` Reproducible SQL experiments (scripts committed, with predictions written before running).
- `[~]` Query-plan comparisons.
- `[ ]` An index-design case study based on a real slow query from my job (anonymized).
- `[ ]` A technical note explaining the observed behavior and production implications.

AI practice: use AI as a research assistant for InnoDB behavior, then verify every claim against the MySQL 8.4 reference manual or an experiment; record any AI claim that turned out wrong.

Exit criteria: `[ ]` given an unseen table, workload, and query, I can predict the plan and the cost of adding an index, then confirm or explain the discrepancy with measurements (Track A index topics at Level 3).

## Month 2 — Backend Architecture and Testing

**Status:** `[ ]`

Focus:
- TypeScript and NestJS design.
- API contracts and domain boundaries.
- Database integration.
- Error handling and validation.
- Integration testing and test strategy.

Practical scope: a throwaway lab service built for this month's exercises and discarded afterwards — a small domain with real invariants is enough (for example a ledger with accounts, entries, and balances, where money is stored as integer minor units or DECIMAL and never as floating point, and balance updates run inside database transactions using what was learned in Month 1, Week 4). Choose a domain with at least one invariant that is genuinely hard to hold under concurrency; the point is the invariant, not the feature set. Alongside it, the real codebase at work is the subject for the review and boundary analysis.

Deliverables:
- `[ ]` A lab service implementing one domain with explicit invariants, structured into controller/service/repository with deliberate module boundaries.
- `[ ]` An explicit business-rule and API specification for it, naming where each invariant is enforced.
- `[ ]` Automated tests covering success, failure, and boundary cases, running against a real MySQL instance in CI.
- `[ ]` A written review of one real module at work: where its business rules live, which boundaries leak, and what I would change.

AI practice: write a project instruction file (CLAUDE.md) for the lab that separates business rules from technical conventions; use AI to draft an implementation plan, then critique it before coding.

Exit criteria: `[ ]` I can explain where each business rule is enforced and why, and my tests catch a deliberately introduced invariant violation.

## Month 3 — Transactions and Reliable Asynchronous Processing

**Status:** `[ ]`

Focus:
- Transactional correctness.
- Concurrency and locking.
- Idempotency.
- Background workers and retries.
- Duplicate events and partial failures.
- Transactional outbox.

Practical scope: a batch-import lab — CSV upload → parse → normalize → deduplicate → write rows that affect a running total. Built on Month 2's lab service, or standalone if that one was discarded. Move it to a background worker (BullMQ) only once the synchronous version shows a real need. The failure modes, not the domain, are the subject.

Deliverables:
- `[ ]` A background processing workflow.
- `[ ]` Automated tests for duplicate processing and retry behavior.
- `[ ]` A documented failure-recovery strategy.
- `[ ]` A reproducible concurrency experiment (concurrent balance updates with at least two concurrency-control strategies compared).

AI practice: have AI review my import workflow for failure modes, then compare its findings with my own list; note what each side missed.

Exit criteria: `[ ]` the import stays correct when the same file is uploaded twice, when a worker is killed mid-run, and when the same transaction arrives concurrently — demonstrated by tests, not by argument.

## Month 4 — Production Readiness and Observability

**Status:** `[ ]`

Focus:
- Docker and deployment.
- Resource management and Node.js runtime behavior.
- Logging, metrics, and tracing.
- Performance diagnosis (load testing, profiling, flame graphs).
- Timeouts, circuit breakers, graceful shutdown.
- Security and operational resilience.

Deliverables:
- `[ ]` A deployable application (multi-stage Docker image, non-root, CI pipeline).
- `[ ]` Health checks and useful operational telemetry (structured logs with correlation IDs, RED metrics, traces).
- `[ ]` A reproducible performance test with a profiled bottleneck and a measured fix.
- `[ ]` An incident simulation (for example, a slow dependency causing cascading failure) and a blameless root-cause analysis.

AI practice: use AI to investigate a simulated incident from logs and traces; I must state my own hypothesis first and confirm it with evidence.

Exit criteria: `[ ]` given a performance or reliability symptom I have not seen before, I can locate the cause with tools and explain it, rather than guess.

## Month 5 — System Design and Advanced Trade-offs

**Status:** `[ ]`

Focus:
- Requirement clarification.
- Workload estimation.
- Data modeling and architectural boundaries.
- Caching and scalability decisions.
- Distributed consistency (outbox, saga, CAP/PACELC) at design level.
- Reliability, cost, and security trade-offs.

Deliverables:
- `[ ]` A system design document for a real system from my job, taken at 100× its current load.
- `[ ]` At least two alternative designs with explicit trade-offs.
- `[ ]` An architecture decision record.
- `[ ]` A design review conducted as a Senior Engineer would conduct it.
- `[ ]` Weekly timed design exercises (45 minutes each, at least four in the month).

AI practice: use AI as a reviewer of my design document, acting as a skeptical senior engineer; I decide which findings to accept and record why.

Exit criteria: `[ ]` in a timed exercise on an unseen problem, I produce estimates, a design, and trade-offs that hold up to follow-up questions.

## Month 6 — Capstone and Readiness Assessment

**Status:** `[ ]`

Focus:
- End-to-end ownership.
- Independent technical decision-making.
- Production-oriented implementation.
- Performance and reliability verification.
- Technical communication, including in English.
- Interview readiness.

Deliverables:
- `[ ]` A completed, demonstrable backend capability, owned end to end (default: the Month 3 import pipeline extended to be resumable, observable, and load-tested). A feature I own at work counts, if I can publish an anonymized account of it.
- `[ ]` A concise architecture document.
- `[ ]` Automated test evidence and operational documentation.
- `[ ]` A retrospective covering mistakes, trade-offs, and improvements.
- `[ ]` Interview preparation: two mock system design interviews, a bank of deep technical questions drawn from my own notes, and five STAR stories from real work.
- `[ ]` A final competency assessment against the initial baseline.

AI practice: build one reusable skill or workflow that I actually used at least three times during the program, and evaluate whether it saved time.

## Six-month level targets

Repeated from TECHNICAL_GROWTH.md Section 8 so the roadmap states its own finish line:

- `[ ]` Level 3 in Track A (database), transactions/concurrency, and idempotent async processing.
- `[ ]` Level 3 in at least two of: observability, performance diagnosis, system design.
- `[ ]` Level 2 minimum in every other area of the baseline table, with no area left at Level 0.
- `[ ]` Level 4 in at least one topic, demonstrated on a real problem from my job.
