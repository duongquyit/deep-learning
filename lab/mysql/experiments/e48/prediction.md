# E48 — prediction

Write this before running anything. Topic: [Layering and business invariants](../../../../topics/layering-business-invariants/index.html), section 05.

Setup: MySQL 8.4, the Month 2 ledger service. Account 1 starts at 100,000 minor
units; each debit is 70,000. Five ways to enforce "balance never negative" (I1),
switched on and off by config: controller check, service read-then-check,
`SELECT … FOR UPDATE` then check, conditional `UPDATE … WHERE balance_minor >= ?`,
`CHECK (balance_minor >= 0)`. Five write paths: one API request, 20 concurrent
API requests, a job calling the service, a job issuing its own `UPDATE`, a
hand-written SQL statement.

1. For each enforcement and each path: how many times does the balance go negative?
   TODO
2. For each combination: what does the client (or the job) receive — status code or MySQL error?
   TODO
3. With only `CHECK` on, what exactly does the NestJS response look like for the API path?
   TODO
4. Does the reconciliation query (balance vs sum of entries) find every damaged account?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
