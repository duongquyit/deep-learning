-- Schema and data generator for the Month 1 lab.
-- Safe to re-run: tables are created only if missing, routines are replaced.
CREATE DATABASE IF NOT EXISTS lab;
USE lab;

-- 0..9999, the row source for the generator.
CREATE TABLE IF NOT EXISTS seq (n INT UNSIGNED NOT NULL PRIMARY KEY) ENGINE=InnoDB;
SET SESSION cte_max_recursion_depth = 10000;
INSERT IGNORE INTO seq
  WITH RECURSIVE s(n) AS (SELECT 0 UNION ALL SELECT n + 1 FROM s WHERE n < 9999)
  SELECT n FROM s;

-- The table the topic pages use: BIGINT PK, 4 secondary indexes.
CREATE TABLE IF NOT EXISTS orders (
  id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  user_id     INT UNSIGNED    NOT NULL,
  created_at  DATETIME        NOT NULL,
  status      ENUM('new','paid','shipped','cancelled') NOT NULL,
  total       INT UNSIGNED    NOT NULL,       -- minor units, never a float
  note        VARCHAR(100)    NOT NULL,
  PRIMARY KEY (id),
  KEY idx_user_id    (user_id),
  KEY idx_created_at (created_at),
  KEY idx_status     (status),
  KEY idx_total      (total)
) ENGINE=InnoDB;

-- E5: same columns and indexes, random UUID stored as text.
CREATE TABLE IF NOT EXISTS orders_uuid (
  id          CHAR(36)        NOT NULL,
  user_id     INT UNSIGNED    NOT NULL,
  created_at  DATETIME        NOT NULL,
  status      ENUM('new','paid','shipped','cancelled') NOT NULL,
  total       INT UNSIGNED    NOT NULL,
  note        VARCHAR(100)    NOT NULL,
  PRIMARY KEY (id),
  KEY idx_user_id    (user_id),
  KEY idx_created_at (created_at),
  KEY idx_status     (status),
  KEY idx_total      (total)
) ENGINE=InnoDB;

-- E8: PK only, so every page split counted belongs to PRIMARY.
CREATE TABLE IF NOT EXISTS e8_seq (
  id BIGINT UNSIGNED NOT NULL, user_id INT UNSIGNED NOT NULL, created_at DATETIME NOT NULL,
  status ENUM('new','paid','shipped','cancelled') NOT NULL, total INT UNSIGNED NOT NULL,
  note VARCHAR(100) NOT NULL, PRIMARY KEY (id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS e8_uuid (            -- random UUIDv4, BINARY(16)
  id BINARY(16) NOT NULL, user_id INT UNSIGNED NOT NULL, created_at DATETIME NOT NULL,
  status ENUM('new','paid','shipped','cancelled') NOT NULL, total INT UNSIGNED NOT NULL,
  note VARCHAR(100) NOT NULL, PRIMARY KEY (id)
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS e8_uuid_ord (        -- UUIDv1 with time bits swapped first
  id BINARY(16) NOT NULL, user_id INT UNSIGNED NOT NULL, created_at DATETIME NOT NULL,
  status ENUM('new','paid','shipped','cancelled') NOT NULL, total INT UNSIGNED NOT NULL,
  note VARCHAR(100) NOT NULL, PRIMARY KEY (id)
) ENGINE=InnoDB;

DELIMITER //

-- Random UUID in v4 format. MySQL's own UUID() is v1 (time-based), which is
-- not what "UUIDv4" means in the experiments.
DROP FUNCTION IF EXISTS uuid_v4 //
CREATE FUNCTION uuid_v4() RETURNS CHAR(36) NOT DETERMINISTIC NO SQL
BEGIN
  DECLARE h CHAR(32) DEFAULT LOWER(HEX(RANDOM_BYTES(16)));
  SET h = CONCAT(SUBSTR(h, 1, 12), '4', SUBSTR(h, 14, 3),
                 SUBSTR('89ab', 1 + ASCII(SUBSTR(h, 17, 1)) % 4, 1), SUBSTR(h, 18, 15));
  RETURN CONCAT(SUBSTR(h, 1, 8), '-', SUBSTR(h, 9, 4), '-', SUBSTR(h, 13, 4), '-',
                SUBSTR(h, 17, 4), '-', SUBSTR(h, 21, 12));
END //

-- Appends `total_rows` rows to `tbl`, `batch` rows per INSERT statement
-- (1..10000; each statement is its own transaction). Row n always gets the same
-- user_id, created_at, status, total and note, so two loads of the same size
-- differ only in their primary keys. user_id = 1 + CRC32 mod `users`, so with
-- users = rows / 10 a user has about 10 orders and some have exactly 3.
DROP PROCEDURE IF EXISTS load_orders //
CREATE PROCEDURE load_orders(IN tbl VARCHAR(64), IN total_rows BIGINT,
                             IN batch INT, IN users INT)
BEGIN
  DECLARE id_expr VARCHAR(100);
  DECLARE done BIGINT DEFAULT 0;
  SET id_expr = CASE tbl
    WHEN 'orders'      THEN 'x.n + 1'
    WHEN 'e8_seq'      THEN 'x.n + 1'
    WHEN 'orders_uuid' THEN 'uuid_v4()'
    WHEN 'e8_uuid'     THEN 'UUID_TO_BIN(uuid_v4())'
    WHEN 'e8_uuid_ord' THEN 'UUID_TO_BIN(UUID(), 1)'
  END;
  IF id_expr IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'load_orders: unknown table';
  END IF;
  IF batch < 1 OR batch > 10000 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'load_orders: batch must be 1..10000';
  END IF;
  -- Continue numbering after the rows already there, so `load` can append.
  SET @sql = CONCAT('SELECT COUNT(*) INTO @have FROM ', tbl);
  PREPARE st FROM @sql; EXECUTE st; DEALLOCATE PREPARE st;
  SET @sql = CONCAT(
    'INSERT INTO ', tbl, ' (id, user_id, created_at, status, total, note) ',
    'SELECT ', id_expr, ', ',
    '1 + CRC32(CONCAT(''u'', x.n)) % ?, ',
    'TIMESTAMP(''2025-01-01'') + INTERVAL x.n * 6 SECOND, ',
    'CASE WHEN CRC32(CONCAT(''s'', x.n)) % 100 < 10 THEN ''new'' ',
    '     WHEN CRC32(CONCAT(''s'', x.n)) % 100 < 70 THEN ''paid'' ',
    '     WHEN CRC32(CONCAT(''s'', x.n)) % 100 < 95 THEN ''shipped'' ',
    '     ELSE ''cancelled'' END, ',
    '10000 + CRC32(CONCAT(''t'', x.n)) % 5000000, ',
    'LEFT(REPEAT(MD5(x.n), 3), 40 + x.n % 57) ',
    'FROM (SELECT ? + n AS n FROM seq WHERE n < ?) AS x');
  PREPARE st FROM @sql;
  SET @users = users;
  WHILE done < total_rows DO
    SET @off = @have + done, @b = LEAST(batch, total_rows - done);
    EXECUTE st USING @users, @off, @b;
    SET done = done + @b;
  END WHILE;
  DEALLOCATE PREPARE st;
END //

DELIMITER ;
