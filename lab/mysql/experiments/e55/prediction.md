# E55 — prediction

Write this before running anything. Topic: [Test strategy with a real MySQL](../../../../topics/test-strategy-real-db/index.html), section 05.

Setup: the Month 2 ledger service. For each of the seven situations in the
page's section 02 table (case-insensitive duplicate email, value too long, CHECK
violation, ONLY_FULL_GROUP_BY, nested START TRANSACTION, SUM returning a string,
crossed-order deadlock), write one test in three forms: service with a mocked
repository; repository on SQLite in-memory; repository on MySQL 8.4 in a
Testcontainers container.

1. Which of the 21 tests fail (go red) against code that has the bug?
   TODO
2. For the SQLite form, which tests fail for a different reason than the MySQL form?
   TODO
3. Two more bugs from the codebase at work that only a real MySQL would catch
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
