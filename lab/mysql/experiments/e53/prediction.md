# E53 — prediction

Write this before running anything. Topic: [Pagination: offset and keyset](../../../../topics/pagination-keyset/index.html), section 05.

Setup: MySQL 8.4 on the lab, same table as E52. Cursor = the 10,000th row of one
user. Claude's sandbox (8.0.46) found that the row-constructor form is never a
range, even on an exactly matching index; this checks 8.4.

1. `WHERE user_id = ? AND (created_at, id) < (?, ?)`: `EXPLAIN` `type`, `key_len`, and `Handler_read_prev`
   TODO
2. The same with `(created_at < ? OR (created_at = ? AND id < ?))`
   TODO
3. No user filter, index `(created_at, id)`: row constructor vs expanded `OR`
   TODO
4. Row constructor plus a redundant `created_at <= ?` in front: does the redundant condition make it a range?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
