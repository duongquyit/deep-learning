#!/usr/bin/env bash
# MySQL lab for Month 1. Run ./lab.sh help for the commands.
set -euo pipefail

LAB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$LAB_DIR"

# Overridable so the same commands can run against a server outside Docker.
MYSQL_CMD="${MYSQL_CMD:-docker compose exec -T -e MYSQL_PWD=lab mysql mysql -uroot}"
READY_CMD="${READY_CMD:-docker compose exec -T -e MYSQL_PWD=lab mysql mysqladmin -uroot -h127.0.0.1 ping --silent}"
RESTART_CMD="${RESTART_CMD:-docker compose restart mysql}"
DB=lab
TABLES="orders orders_uuid e8_seq e8_uuid e8_uuid_ord"

sql()  { $MYSQL_CMD --table "$DB" "$@"; }   # results as tables, for reading
sqlv() { $MYSQL_CMD -N -B "$DB" "$@"; }     # bare values, for scripts
now()  { date +%s.%N; }
die()  { echo "lab: $*" >&2; exit 1; }

check_table() {
  local t
  for t in $TABLES; do [[ "$1" == "$t" ]] && return 0; done
  die "unknown table '$1' (one of: $TABLES)"
}

wait_ready() {
  local i
  for i in $(seq 1 120); do
    if $READY_CMD >/dev/null 2>&1 && sqlv -e 'SELECT 1' >/dev/null 2>&1; then return 0; fi
    sleep 1
  done
  die "server did not become ready in 120s"
}

# --- setup -----------------------------------------------------------------

cmd_up() {
  docker compose up -d
  echo "waiting for MySQL..."
  wait_ready
  cmd_schema
  sql -e "SELECT VERSION() AS version, @@innodb_buffer_pool_size DIV 1048576 AS buffer_pool_mb,
                 @@innodb_page_size AS page_size, @@innodb_flush_method AS flush_method,
                 @@innodb_adaptive_hash_index AS ahi"
}

cmd_down()   { docker compose down; }
cmd_schema() { $MYSQL_CMD < sql/schema.sql; echo "schema ok"; }
cmd_shell()  { $MYSQL_CMD "$DB"; }

# load TABLE [ROWS] [BATCH]: empty TABLE, then generate ROWS rows into it.
cmd_load() {
  local t="${1:-orders}" rows="${2:-5000000}" batch="${3:-10000}"
  check_table "$t"
  [[ "$rows" =~ ^[0-9]+$ && "$batch" =~ ^[0-9]+$ ]] || die "rows and batch must be integers"
  local users=$(( rows / 10 > 0 ? rows / 10 : 1 ))
  sqlv -e "TRUNCATE TABLE $t"
  echo "loading $rows rows into $t, $batch rows per statement..."
  local t0 t1; t0=$(now)
  sqlv -e "CALL load_orders('$t', $rows, $batch, $users)"
  t1=$(now)
  sqlv -e "ANALYZE TABLE $t" >/dev/null
  awk -v a="$t0" -v b="$t1" -v n="$rows" \
    'BEGIN { s = b - a; printf "loaded in %.1fs, %.0f rows/s\n", s, n / s }'
  cmd_sizes "$t"
}

# sizes [TABLE]: on-disk size of every index, from InnoDB's own page counts.
cmd_sizes() {
  local where="s.table_name <> 'seq'"
  if [[ -n "${1:-}" ]]; then check_table "$1"; where="s.table_name = '$1'"; fi
  local tables="${1:-$TABLES}"
  sqlv -e "ANALYZE TABLE ${tables// /, }" >/dev/null
  sql -e "
    SELECT s.table_name, s.index_name,
           s.stat_value AS pages,
           l.stat_value AS leaf_pages,
           ROUND(s.stat_value * @@innodb_page_size / 1048576, 1) AS mb
    FROM mysql.innodb_index_stats s
    JOIN mysql.innodb_index_stats l
      ON l.database_name = s.database_name AND l.table_name = s.table_name
     AND l.index_name = s.index_name AND l.stat_name = 'n_leaf_pages'
    WHERE s.database_name = 'lab' AND s.stat_name = 'size' AND $where
    ORDER BY s.table_name, s.index_name = 'PRIMARY' DESC, s.index_name"
}

# cold: restart the server; with lab.cnf the buffer pool comes back empty.
cmd_cold() {
  $RESTART_CMD >/dev/null 2>&1 || die "restart failed: $RESTART_CMD"
  wait_ready
}

# --- measurement -------------------------------------------------------------

# Pages of TABLE's tablespace currently in the buffer pool, per index and
# page type. Non-index pages (the change-buffer bitmap, for one) show as "-".
cmd_pages() {
  local t="${1:-orders}" out; check_table "$t"
  out=$(sql -e "
    SELECT IFNULL(INDEX_NAME, '-') AS index_name, PAGE_TYPE AS page_type,
           COUNT(*) AS pages_in_buffer_pool, SUM(NUMBER_RECORDS) AS records_on_those_pages
    FROM information_schema.INNODB_BUFFER_PAGE
    WHERE SPACE = (SELECT SPACE FROM information_schema.INNODB_TABLESPACES WHERE NAME = 'lab/$t')
      AND PAGE_STATE = 'FILE_PAGE'
    GROUP BY INDEX_NAME, PAGE_TYPE
    ORDER BY INDEX_NAME IS NULL, INDEX_NAME = 'PRIMARY' DESC, INDEX_NAME, PAGE_TYPE")
  echo "${out:-(no pages of $t in the buffer pool)}"
}

# Wait until nothing touches pages: after a restart background threads keep
# reading for a while, and the first read of each performance_schema table
# loads its definition from the (InnoDB) data dictionary. Both land in the
# same global counters as the query.
wait_quiet() {
  local i quiet=0 d
  for i in $(seq 1 60); do
    d=$($MYSQL_CMD -N -B "$DB" <<'SQL'
SELECT VARIABLE_VALUE INTO @k FROM performance_schema.session_status WHERE VARIABLE_NAME = 'Handler_read_key';
SELECT VARIABLE_VALUE INTO @a FROM performance_schema.global_status WHERE VARIABLE_NAME = 'Innodb_buffer_pool_read_requests';
DO SLEEP(0.5);
SELECT VARIABLE_VALUE INTO @b FROM performance_schema.global_status WHERE VARIABLE_NAME = 'Innodb_buffer_pool_read_requests';
SELECT @b - @a;
SQL
)
    if [[ "$d" == 0 ]]; then quiet=$((quiet + 1)); else quiet=0; fi
    if (( quiet >= 3 )); then echo "(server quiet: no page accesses for 1.5s)"; return 0; fi
  done
  echo "(warning: server never went quiet in 30s; global counters include background work)"
}

# Snapshot of the four counters into @<p>rr, @<p>r, @<p>k, @<p>n.
snap() {
  cat <<SQL
SELECT VARIABLE_VALUE INTO @${1}rr FROM performance_schema.global_status  WHERE VARIABLE_NAME = 'Innodb_buffer_pool_read_requests';
SELECT VARIABLE_VALUE INTO @${1}r  FROM performance_schema.global_status  WHERE VARIABLE_NAME = 'Innodb_buffer_pool_reads';
SELECT VARIABLE_VALUE INTO @${1}k  FROM performance_schema.session_status WHERE VARIABLE_NAME = 'Handler_read_key';
SELECT VARIABLE_VALUE INTO @${1}n  FROM performance_schema.session_status WHERE VARIABLE_NAME = 'Handler_read_next';
SQL
}

# One run of SQL in one session. Handler_* are per session: the cost of the
# snapshot statements is measured on a "DO 0" first and subtracted. The
# buffer-pool counters are global and cannot be corrected that way, so they
# are reported raw, next to the DO 0 window as a noise check: run on an idle
# server, after wait_quiet.
measure() {
  local q="$1"
  $MYSQL_CMD --table "$DB" <<SQL
$(snap a)
DO 0;
$(snap b)
$(snap c)
$q;
$(snap d)
SELECT @drr - @crr AS page_accesses, @dr - @cr AS read_from_disk,
       @brr - @arr AS noise_page_accesses,
       (@dk  - @ck)  - (@bk  - @ak)  AS handler_read_key,
       (@dn  - @cn)  - (@bn  - @an)  AS handler_read_next;
SQL
}

# reads "SQL": the plan, then the same query cold and warm, with the pages it
# pulled into the buffer pool. Only meaningful for queries on `orders`.
cmd_reads() {
  local q="$1"
  echo "## $q"
  echo; echo "### plan"
  sql -e "EXPLAIN $q"
  sql -e "EXPLAIN FORMAT=TREE $q"
  cmd_cold
  # Open the table once without reading any of its pages, so the cold run
  # does not also pay for loading the table definition from the dictionary.
  sqlv -e "SELECT * FROM orders LIMIT 0"
  wait_quiet
  echo "### cold server, before the query"
  cmd_pages orders
  echo "### cold run"
  measure "$q"
  echo "### pages of orders in the buffer pool after the cold run"
  cmd_pages orders
  echo "### warm run"
  wait_quiet
  measure "$q"
}

# latency "SQL" [N]: run SQL N times in one session, report the
# server-side latency from performance_schema (histogram-based quantiles).
cmd_latency() {
  local q="$1" n="${2:-200}"
  [[ "$n" =~ ^[0-9]+$ ]] || die "N must be an integer"
  sqlv -e "TRUNCATE TABLE performance_schema.events_statements_summary_by_digest"
  for _ in $(seq 1 "$n"); do printf '%s;\n' "$q"; done | sqlv >/dev/null
  sql -e "
    SELECT COUNT_STAR AS runs,
           ROUND(AVG_TIMER_WAIT / 1e9, 3) AS avg_ms,
           ROUND(QUANTILE_95 / 1e9, 3)    AS p95_ms,
           ROUND(QUANTILE_99 / 1e9, 3)    AS p99_ms,
           ROUND(MAX_TIMER_WAIT / 1e9, 3) AS max_ms,
           ROUND(SUM_ROWS_EXAMINED / COUNT_STAR, 1) AS rows_examined,
           LEFT(DIGEST_TEXT, 60) AS query
    FROM performance_schema.events_statements_summary_by_digest
    WHERE SCHEMA_NAME = 'lab'
    ORDER BY COUNT_STAR DESC LIMIT 1"
}

# --- experiments -------------------------------------------------------------

# Principle 2: predict before running. An experiment refuses to start while
# its prediction file still contains TODO.
require_prediction() {
  local f="experiments/$1/prediction.md"
  [[ -f "$f" ]] || die "missing $f"
  if grep -q 'TODO' "$f" && [[ "${LAB_SKIP_PREDICTION:-0}" != 1 ]]; then
    die "write your prediction in $f first (remove every TODO), then run again"
  fi
}

results_file() {
  mkdir -p "experiments/$1/results"
  echo "experiments/$1/results/$(date +%Y-%m-%d-%H%M)${LAB_RESULT_TAG:+-$LAB_RESULT_TAG}.md"
}

header() {
  echo "# $1"
  echo
  echo "Run at $(date '+%Y-%m-%d %H:%M %z') on $(uname -sm), $(getconf _NPROCESSORS_ONLN 2>/dev/null || echo '?') CPUs (host side)."
  sql -e "SELECT VERSION() AS version, @@innodb_buffer_pool_size DIV 1048576 AS buffer_pool_mb,
                 @@innodb_page_size AS page_size, @@innodb_flush_method AS flush_method,
                 @@innodb_adaptive_hash_index AS ahi, @@log_bin AS binlog"
}

table_rows() { sqlv -e "SELECT COUNT(*) FROM $1"; }

cmd_e5() {
  require_prediction e5
  local a b; a=$(table_rows orders); b=$(table_rows orders_uuid)
  [[ "$a" -gt 0 && "$a" == "$b" ]] || die "load the same number of rows into both tables first:
  ./lab.sh load orders 5000000 && ./lab.sh load orders_uuid 5000000   (now: $a vs $b)"
  local out; out=$(results_file e5)
  {
    header "E5 — PK type and secondary index size ($a rows each)"
    cmd_sizes orders
    cmd_sizes orders_uuid
    echo "### every index, orders_uuid / orders"
    sql -e "
      SELECT u.index_name, b.stat_value AS bigint_pages, u.stat_value AS uuid_pages,
             ROUND(u.stat_value / b.stat_value, 2) AS ratio
      FROM mysql.innodb_index_stats u
      JOIN mysql.innodb_index_stats b
        ON b.database_name = 'lab' AND b.table_name = 'orders'
       AND b.index_name = u.index_name AND b.stat_name = 'size'
      WHERE u.database_name = 'lab' AND u.table_name = 'orders_uuid' AND u.stat_name = 'size'
      ORDER BY u.index_name = 'PRIMARY' DESC, u.index_name"
  } | tee "$out"
  echo "saved $out"
}

cmd_e6() {
  require_prediction e6
  [[ "$(table_rows orders)" -gt 0 ]] || die "load data first: ./lab.sh load orders 5000000"
  local user
  user=$(sqlv -e "SELECT user_id FROM orders GROUP BY user_id HAVING COUNT(*) = 3 ORDER BY user_id LIMIT 1")
  [[ -n "$user" ]] || die "no user with exactly 3 orders"
  local out; out=$(results_file e6)
  {
    header "E6 — reading rows through idx_user_id (user_id = $user, 3 orders)"
    sql -e "SELECT id, user_id, created_at, status, total FROM orders WHERE user_id = $user"
    cmd_sizes orders
    cmd_reads "SELECT * FROM orders WHERE user_id = $user"
    cmd_reads "SELECT id FROM orders WHERE user_id = $user"
    echo "### warm latency"
    cmd_latency "SELECT * FROM orders WHERE user_id = $user" 500
    cmd_latency "SELECT id FROM orders WHERE user_id = $user" 500
  } 2>&1 | tee "$out"
  echo "saved $out"
}

cmd_e8() {
  require_prediction e8
  local rows="${1:-1000000}" batch="${2:-1000}"
  local out; out=$(results_file e8)
  {
    header "E8 — inserting $rows rows, $batch per statement, PK only"
    printf '| table | seconds | rows/s | page splits | PRIMARY pages | leaf pages | rows per leaf |\n'
    printf '|---|---|---|---|---|---|---|\n'
    local t s0 s1 t0 t1 pages leaves
    for t in e8_seq e8_uuid_ord e8_uuid; do
      sqlv -e "TRUNCATE TABLE $t"
      s0=$(sqlv -e "SELECT COUNT FROM information_schema.INNODB_METRICS WHERE NAME = 'index_page_splits'")
      t0=$(now)
      sqlv -e "CALL load_orders('$t', $rows, $batch, $(( rows / 10 )))"
      t1=$(now)
      s1=$(sqlv -e "SELECT COUNT FROM information_schema.INNODB_METRICS WHERE NAME = 'index_page_splits'")
      sqlv -e "ANALYZE TABLE $t" >/dev/null
      pages=$(sqlv -e "SELECT stat_value FROM mysql.innodb_index_stats WHERE database_name='lab' AND table_name='$t' AND index_name='PRIMARY' AND stat_name='size'")
      leaves=$(sqlv -e "SELECT stat_value FROM mysql.innodb_index_stats WHERE database_name='lab' AND table_name='$t' AND index_name='PRIMARY' AND stat_name='n_leaf_pages'")
      awk -v t="$t" -v a="$t0" -v b="$t1" -v n="$rows" -v sp=$(( s1 - s0 )) -v p="$pages" -v l="$leaves" \
        'BEGIN { s = b - a; printf "| %s | %.1f | %.0f | %d | %d | %d | %.1f |\n", t, s, n / s, sp, p, l, n / l }'
    done
  } 2>&1 | tee "$out"
  echo "saved $out"
}

cmd_help() {
  cat <<'EOF'
Usage: ./lab.sh COMMAND [ARGS]

Setup
  up                       start MySQL 8.4, wait, load the schema
  down                     stop the container (data volume is kept)
  schema                   (re)create tables and routines
  shell                    mysql client on database lab
  load TABLE [ROWS] [B]    empty TABLE, generate ROWS rows (default 5000000), B per statement

Measure
  sizes [TABLE]            pages and MB per index
  cold                     restart: empty buffer pool
  pages [TABLE]            pages of TABLE in the buffer pool, per index
  reads "SQL"              plan, then page counts for one cold and one warm run
  latency "SQL" [N]        run N times (default 200), avg / p95 / p99 from performance_schema

Experiments (write experiments/<id>/prediction.md first)
  e5                       PK type vs secondary index size (needs orders + orders_uuid loaded)
  e6                       secondary index lookup, cold and warm (needs orders loaded)
  e8 [ROWS] [B]            insert ROWS (1000000) with sequential / ordered / random PK
EOF
}

cmd="${1:-help}"; shift || true
case "$cmd" in
  up|down|schema|shell|load|sizes|cold|pages|reads|latency|e5|e6|e8|help) "cmd_$cmd" "$@" ;;
  *) cmd_help; exit 1 ;;
esac
