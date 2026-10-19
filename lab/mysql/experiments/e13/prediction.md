# E13 — prediction

Write this before running anything. Topic: [index write cost](../../../../topics/index-write-cost/index.html), section 05.

Setup: four copies of `orders` with 0, 2, 5 and 8 secondary indexes (the index
sets in section 01 of the page), each loaded with the same 1,000,000 rows from
`load_orders` with the same seed. Buffer pool as in `lab.cnf`.

1. Insert time for each of the four tables. Does it grow linearly with the number of indexes? If not, where does it bend, and why?
   TODO
2. Total size (all indexes, from `mysql.innodb_index_stats`, `stat_name = 'size'`) for each table.
   TODO
3. Which secondary index is the largest, and which has the lowest rows per leaf page? Why?
   TODO
4. How far are your numbers from the size calculator in section 02 of the page?
   TODO

## After the run

Paste the outputs you got, then write where the prediction was wrong and why.
