# E51 — prediction

Write this before running anything. Topic: [Validation and error contracts](../../../../topics/validation-error-contracts/index.html), section 05.

Setup: the Month 2 app with the page's `ProblemFilter` and `exceptionFactory`,
MySQL 8.4. Cause each error for real: malformed JSON; duplicate email (1062);
a deadlock between two sessions (1213); a lock wait with
`innodb_lock_wait_timeout = 1` (1205); a `TypeError` thrown in a service.

1. For each error: status, `code`, `Retry-After` header
   TODO
2. Does any response body contain SQL text, an index name, a column value or a stack frame?
   TODO
3. After the 1205 case, is any row written earlier in the same transaction committed? (default `innodb_rollback_on_timeout = OFF`)
   TODO
4. Does the malformed-JSON error reach the `@Catch()` filter, or does the default filter answer it?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
