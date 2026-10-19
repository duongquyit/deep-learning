# E8 — prediction

Write this before running `./lab.sh e8`. The script refuses to run while this
file still contains the word TODO.

Setup: three tables with only a primary key, 1,000,000 rows each, inserted
1,000 rows per statement (each statement commits):

- `e8_seq`: `BIGINT`, ascending
- `e8_uuid_ord`: `UUID_TO_BIN(UUID(), 1)`, time bits first, so mostly ascending
- `e8_uuid`: `UUID_TO_BIN(uuid_v4())`, random

1. Rank the three by insert throughput, and estimate the gap between first and last.
   TODO
2. Page splits for each table. Why is the number for `e8_seq` not zero, and what kind of split is it?
   TODO
3. Rows per leaf page for each. What fill factor does that imply for the random table?
   TODO
4. Does `e8_uuid_ord` behave like `e8_seq` or like `e8_uuid`? Why?
   TODO

## After the run

Compare with the results file. Where the prediction was wrong, write why here.
