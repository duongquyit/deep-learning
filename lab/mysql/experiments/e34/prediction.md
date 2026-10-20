# E34 — prediction

Write this before running anything. Topic: [BullMQ workers and resumable batches](../../../../topics/bullmq-workers-resumable/index.html), section 05.

Setup: a 200,000-row CSV; batches of 500 rows, one transaction each; a supervised
worker process restarted after every death; a script that sends `SIGKILL` at 5
random moments. Run three variants of checkpointing, each once with and once
without the `(import_id, row_no)` primary key on `import_rows`.

For each variant: rows processed in total, rows in `import_rows`, duplicate rows,
`SUM(amount)` vs the file's total, and wall-clock time.

1. No checkpoint (restart from row 1)
   TODO
2. Checkpoint in Redis with `job.updateData` after the MySQL commit
   TODO
3. Checkpoint in `imports.cursor_row`, same transaction as the batch
   TODO
4. Does the result match the calculator in section 02?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
