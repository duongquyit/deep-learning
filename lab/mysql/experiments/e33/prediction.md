# E33 — prediction

Write this before running anything. Topic: [BullMQ workers and resumable batches](../../../../topics/bullmq-workers-resumable/index.html), section 05.

Setup: Redis and MySQL in Docker, BullMQ with default worker options, two worker
processes. The job runs 90 s: `await sleep` for 20 s, a synchronous busy loop for
40 s, then `await sleep` for 30 s. Each time a worker starts the job it inserts a
row into a MySQL `job_runs` table. Listen to `QueueEvents` for `stalled`,
`failed`, `completed`.

1. Is a `stalled` event emitted? At about which second?
   TODO
2. Does worker B pick the job up while worker A is still running it? How many rows end up in `job_runs`?
   TODO
3. Final state of the job, and its failed reason if any. (open question 27)
   TODO
4. What does worker A log when it finishes?
   TODO
5. Same job with a sandboxed processor (file path instead of a function): answers to 1–3.
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
