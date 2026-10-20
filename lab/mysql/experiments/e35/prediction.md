# E35 — prediction

Write this before running anything. Topic: [BullMQ workers and resumable batches](../../../../topics/bullmq-workers-resumable/index.html), section 05.

Setup: as E34 with checkpoint in MySQL and batches that take 10 s each. Send
`SIGTERM` in the middle of a batch. Two variants: a handler that awaits
`worker.close()` then exits, and no handler at all.

For each variant:

1. How long until the process exits?
   TODO
2. State of the job right after exit, and how long until another worker runs it?
   TODO
3. From which row does the next run start?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
