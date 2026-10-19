# E15 — prediction

Write this before running anything. Topic: [index write cost](../../../../topics/index-write-cost/index.html), section 05.

Setup: `orders` with 5,000,000 rows. Delete 60% of rows
(`id % 5 IN (0, 1, 2)`) in batches of 10,000, wait until `History list length`
in `SHOW ENGINE INNODB STATUS` is close to 0, then `OPTIMIZE TABLE orders`.

1. How much do `index_page_merge_attempts` and `index_page_merge_successful` grow during the delete and purge?
   TODO
2. `n_leaf_pages` of PRIMARY and of `idx_user_id`: before the delete, after purge, after `OPTIMIZE TABLE`.
   TODO
3. Size of `orders.ibd` on disk at the same three points.
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
