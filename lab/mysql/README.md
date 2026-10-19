# Lab MySQL 8.4 cho Month 1

Lab cho Week 1 của [ROADMAP.md](../../.claude/docs/ROADMAP.md): MySQL 8.4 trong Docker, data generator cho bảng `orders` hàng triệu row, và một cách đo latency, page đọc và insert throughput mà lần nào chạy cũng cho kết quả so sánh được. Các thí nghiệm E5, E6 và E8 từ [trang clustered vs secondary index](../../topics/clustered-vs-secondary-index/index.html) chạy được ngay trên lab này.

## Cần có

- Docker Engine hoặc Docker Desktop có `docker compose` (v2).
- Khoảng 3 GB RAM cho Docker: buffer pool cố định 1 GB, cộng phần còn lại của server.
- Khoảng 4 GB disk: 5 triệu row `orders` chiếm khoảng 1 GB, `orders_uuid` cùng số row còn lớn hơn.

## Bắt đầu

```bash
cd lab/mysql
./lab.sh up                        # chạy MySQL 8.4, chờ server sẵn sàng, tạo schema
./lab.sh load orders 5000000       # khoảng 2 đến 3 phút trên laptop
./lab.sh sizes orders              # số page và MB của từng index
./lab.sh latency "SELECT * FROM orders WHERE user_id = 196" 500
```

`./lab.sh shell` mở mysql client trên database `lab`. Từ máy host thì kết nối qua `127.0.0.1:3307`, user `root`, mật khẩu `lab`. Lab dùng port 3307 để không đụng MySQL đang chạy sẵn trên máy.

## Các lệnh

| Lệnh | Làm gì |
|---|---|
| `up` / `down` | Bật hoặc tắt container. `down` giữ nguyên data |
| `schema` | Tạo lại bảng và routine, chạy lại bao nhiêu lần cũng được |
| `load TABLE [ROWS] [B]` | Xoá sạch TABLE rồi sinh ROWS row, B row mỗi statement (tối đa 10000) |
| `sizes [TABLE]` | Số page, số leaf page và MB của từng index, lấy từ `mysql.innodb_index_stats` |
| `cold` | Restart server. Với `lab.cnf`, buffer pool khởi động lại ở trạng thái rỗng |
| `pages [TABLE]` | Page nào của bảng đang nằm trong buffer pool, chia theo index và loại page |
| `reads "SQL"` | Plan, rồi chạy query một lần cold và một lần warm, kèm số page đã đọc |
| `latency "SQL" [N]` | Chạy N lần trong một session, báo avg, p95, p99 và max phía server |
| `e5`, `e6`, `e8` | Các thí nghiệm, ghi kết quả vào `experiments/<id>/results/` |

Sáu bảng có sẵn: `orders` (PK `BIGINT`, 4 secondary index), `orders_uuid` (PK `CHAR(36)` UUIDv4, cùng 4 index), `e8_seq`, `e8_uuid`, `e8_uuid_ord` (chỉ có PK), và `seq` là bảng số dùng cho generator.

Data sinh ra là tất định: row thứ n lúc nào cũng có cùng `user_id`, `created_at`, `status`, `total` và `note`. Hai lần load cùng số row chỉ khác nhau ở primary key. Mỗi user có trung bình 10 đơn, nên luôn tìm được user có đúng 3 đơn cho E6.

## Một thí nghiệm chạy thế nào

Quy trình theo Principle 2 trong [TECHNICAL_GROWTH.md](../../.claude/docs/TECHNICAL_GROWTH.md): dự đoán, chạy, so sánh, giải thích chỗ lệch.

1. Mở `experiments/<id>/prediction.md` và tự viết câu trả lời kèm lý do, trước khi hỏi AI hay tra tài liệu. Script từ chối chạy khi file còn chữ `TODO`.
2. Chạy `./lab.sh e6` (hoặc `e5`, `e8`). Kết quả được in ra màn hình và ghi vào `experiments/e6/results/<ngày-giờ>.md`, có kèm version, cấu hình và thông tin máy.
3. Ghi vào phần "After the run" của file dự đoán những chỗ đoán sai và lý do sai.
4. Commit cả file dự đoán lẫn file kết quả, rồi thêm một mục vào `LEARNING_LOG.md`. Kết quả này là bằng chứng để nâng level trong bảng năng lực.

E5 cần load cả hai bảng với cùng số row: `./lab.sh load orders 5000000 && ./lab.sh load orders_uuid 5000000`. E8 tự load bảng của nó: `./lab.sh e8 [ROWS] [B]`, mặc định 1 triệu row, 1000 row mỗi statement.

## Đọc số đo cho đúng

- **`page_accesses`** (`Innodb_buffer_pool_read_requests`) đếm số lần InnoDB lấy một page, dù page đó đã có sẵn trong buffer pool. **`read_from_disk`** (`Innodb_buffer_pool_reads`) chỉ đếm những lần phải đọc từ disk.
- Hai bộ đếm đó là của cả server. Vì vậy `reads` chờ server yên hẳn rồi mới đo, và in thêm `noise_page_accesses` là số đo của một câu `DO 0`. Cột này khác 0 nghĩa là có thứ khác đang chạy cùng lúc, số đo lần đó không dùng được.
- `handler_read_key` và `handler_read_next` là bộ đếm theo session, đã trừ phần do chính các câu đo gây ra.
- `pages` liệt kê page theo cả loại. Page không thuộc index nào hiện `index_name` là `-`. Tra cột `page_type` trong tài liệu InnoDB để biết nó là gì và vì sao query lại cần nó.
- p95 và p99 lấy từ histogram của performance_schema, nên là giá trị xấp xỉ theo bucket.
- Số đo chỉ so sánh được khi cùng máy và cùng cấu hình. Khi so với lần chạy trước, đọc phần header của file kết quả trước tiên.

## Cấu hình

Lý do của từng dòng nằm ngay trong [conf/lab.cnf](conf/lab.cnf). Ba dòng quan trọng nhất:

- Buffer pool không dump khi shutdown và không load lại khi startup, nên `cold` thực sự là cold.
- `O_DIRECT` bỏ qua page cache của hệ điều hành, nên "đọc từ disk" là đọc thật. Trên Docker Desktop (macOS, Windows), "disk" là disk của VM.
- Adaptive hash index tắt, để lookup luôn đi qua B+tree, đúng như các topic page mô tả.

## Chạy ngoài Docker

Ba biến môi trường cho phép chạy cùng các lệnh trên với một server MySQL khác. Đã cài `conf/lab.cnf` vào server đó thì số đo mới có nghĩa:

```bash
MYSQL_CMD="mysql -uroot" READY_CMD="mysqladmin -uroot ping --silent" \
RESTART_CMD="sudo service mysql restart" ./lab.sh e6
```

## Xoá lab

```bash
docker compose down -v   # xoá luôn volume chứa data
```
