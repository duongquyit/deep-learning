# Content conventions

Every topic page follows one fixed document structure, agreed with the author
on 2026-10-19, extended with section 9 (Bài toán thực tế) on 2026-10-20, with section 9 switched to the interview format on 2026-10-21. The sections, their order and their headings are the same on
every page, so a reader always knows where to look, and so recall, open
questions and experiments can be tracked across topics.

## Document structure

Twelve parts, in this order. Parts 1 to 11 are numbered sections (`01` to
`11`) with exactly these Vietnamese headings; the topic goes in the text, not
in the heading.

| # | Heading on the page | Purpose |
|---|---|---|
| 0 | (hero, no number) | Title, lede, and a box with **Mục tiêu**, **Cần biết trước**, **Trạng thái** |
| 1 | Bản chất vấn đề | Core concept. Open with the problem, then the idea, then the topic's main widget |
| 2 | Cơ chế hoạt động | How it works inside. One `h3` per mechanism, one widget per mechanism |
| 3 | Vì sao thiết kế như vậy | Why: the trade-off behind each mechanism, alternatives, other engines |
| 4 | Ví dụ | Runnable SQL, code or commands that illustrate. Not evidence |
| 5 | Thí nghiệm | Experiments: question, prediction, command, result, discrepancy |
| 6 | Ảnh hưởng khi chạy production | When to use and not, what it costs, how to detect it in production, a review checklist |
| 7 | Hiểu lầm thường gặp | Summary of misconceptions |
| 8 | Câu hỏi ôn tập | Recall questions with hidden answers |
| 9 | Bài toán thực tế | Real-world cases as senior interview questions: the question is shown, clarifications, follow-up answers and a rubric are hidden |
| 10 | Câu hỏi còn mở | Open questions with status |
| 11 | Tài liệu tham khảo | Sources, and how far each claim has been verified |

The TOC lists the eleven numbered sections. Pages written before 2026-10-20
have ten (no section 9 yet); they gain it when they are next revised, and the
numbers of the last two sections shift by one then. A section may have `h3` subsections;
section 2 almost always does.

### 0. Hero

- `h1` names the topic and its scope.
- A one-paragraph lede.
- A `.brief` box with three short blocks:
  - **Mục tiêu**: 2 to 4 outcomes, each a verb the reader can be tested on
    ("dự đoán được `type` và `key_len` của…", "giải thích được vì sao…").
    Recall questions are written against these.
  - **Cần biết trước**: earlier topic pages this one builds on, linked.
  - **Trạng thái**: the author's competency level for the topic (from the
    matrix in `LEARNING_LOG.md`), and whether anything on the page has been
    measured by the author or is still a model.
- No widget in the hero. The main widget goes in section 1.

### 1. Bản chất vấn đề

Start from a concrete problem: a query, a symptom, a question an engineer
actually has. Then the core idea in a few sentences, with a short analogy if
it helps (placed before the mechanism, not instead of it). End with the
topic's most characteristic widget, the one that lets the reader play with
the whole idea.

### 2. Cơ chế hoạt động

One `h3` per mechanism. Each follows: short explanation (2 to 5 short
paragraphs or a list), then the widget, then the takeaway in one or two
sentences. A **Lỗi hay gặp** callout goes right where the reader is about to
make that mistake, not only in section 7.

### 3. Vì sao thiết kế như vậy

For each mechanism in section 2, the reason it works that way and what it
gives up. Compare with the alternative designs and with other engines
(InnoDB, PostgreSQL, others) in a table when behaviour differs.

### 4. Ví dụ

Code blocks the reader can run: DDL, queries, `EXPLAIN` output, rewrites
(bad version, good version). Say where each output came from (manual,
Claude's sandbox and its version, the author's lab). An example illustrates;
it never counts as evidence for a competency level.

### 5. Thí nghiệm

The experiments that turn the page into evidence. Each in a `<details>`,
with these labelled parts:

1. **Câu hỏi**: what is being tested.
2. **Dự đoán**: points to `lab/mysql/experiments/eN/prediction.md`, written
   before running. Never fill it in for the author.
3. **Chạy**: the exact commands.
4. **Kết quả**: "chưa chạy" until the author runs it; then the numbers and a
   link to the results file.
5. **Chỗ lệch**: where the prediction was wrong and why. Empty until run.

Every experiment gets a `prediction.md` template in the lab, with `TODO`
under each question, in the same commit as the page.

### 6. Ảnh hưởng khi chạy production

Must answer all four:

- When to use it, when not, and what to use instead.
- What it costs: writes, RAM, disk, locks, operational work.
- How to notice it in production: which metric, log, `performance_schema` or
  `sys` view, which `EXPLAIN` field.
- A short checklist a reviewer can apply to a pull request.

**Góc nhìn senior** callouts live here mostly.

### 7. Hiểu lầm thường gặp

A list. Each item has three parts: **Hiểu lầm**, **Vì sao sai**, **Quy tắc**.
Link back to the inline callout when there is one. Mark the ones the author
actually made during the session with "(đã mắc)"; never guess which.

### 8. Câu hỏi ôn tập

Five or more questions for spaced review, mixing three kinds, each tagged:

- **Giải thích**: explain a mechanism or a trade-off.
- **Dự đoán**: given a table, index and query, predict the plan or the cost.
- **Chẩn đoán**: given a symptom, find the cause and how to confirm it.

Each question is a `<details>` whose body holds the question and a nested
`<details class="answer"><summary>Xem đáp án</summary>…</details>`. Write the
date the questions were written (`Viết ngày 2026-10-19`) at the top of the
section; monthly checkpoints draw spaced-review questions from here.

### 9. Bài toán thực tế

Practice in the shape of a senior system-design interview, so the reader
rehearses decisions and their defence rather than recall. Three cases per
page, numbered globally like recall questions (`C1`, `C2`, …; the log tracks
the next free number). Each case is a `.case` block (markup in `style.md`).
The section opens with the standard paragraph on how to use it (answer each
part before opening it, the last follow-up is always implementation, grade
yourself with the rubric) and the date the cases were written.

**Shown:** a short title, the pages the case draws on (`p.src`), and the
interviewer's question in `blockquote.q`: one or two sentences in the
interviewer's voice, open-ended, with the minimum context an interviewer
gives. Numbers, code and constraints are not in the question; the reader must
ask for them.

**Hidden, in this order:**

1. **Hỏi lại interviewer** (`details.answer.clar`, summary `Hỏi lại
   interviewer: nên hỏi gì, và interviewer trả lời gì`): a table with columns
   câu nên hỏi, interviewer trả lời, vì sao câu này quan trọng; five to seven
   rows. This is where every number, constraint, current code and incident
   detail lives; the follow-ups rely on it. Close with one paragraph,
   `Senior thường làm gì ở bước này`.
2. **Four or five follow-ups** (`div.fu`, each `p.fq` with `<b>Follow-up N.</b>`
   then the question, then `details.answer` with summary `Đáp án`). They dig
   in the order an interviewer would: the diagnosis, the tempting proposal
   (often a colleague's) and why it fails, the estimate that decides the
   design, the failure mode or edge case, scale or team concerns. Where there
   is a choice, the answer has an options table (at least three options,
   including the tempting wrong one, with ưu điểm and nhược điểm), the
   decision, and when a different option would win. Numbers are worked out
   step by step and labelled as estimates.
3. **The last follow-up is always implementation and verification**
   ("Bạn triển khai và kiểm chứng … thế nào?"): schema, statements or code,
   order of steps, the tests that prove it, the metrics to watch, and how to
   roll back.
4. **Rubric** (`details.answer.rubric`, summary `Rubric: mid, senior, red
   flag`): a table with columns tiêu chí, câu trả lời mức mid, câu trả lời
   mức senior (four to six rows), then a `Red flag` paragraph listing the
   answers that fail the interview.

Case answers are reasoning written from reading, not measurements. A number in
them is an estimate unless it cites an experiment that was run.

### 10. Câu hỏi còn mở

What is not understood yet or needs research. Each item has the same number
as in Open questions of `LEARNING_LOG.md` (the log is the source of truth),
a status (`mở`, `đã trả lời một phần`, `đã trả lời`, `bỏ`) and, once
answered, by what (an experiment, a manual section) and when. Change the
status in the log and on the page in the same commit.

### 11. Tài liệu tham khảo

Links to the exact sections of the reference manual and other primary
sources. Then a short verification table: each key claim on the page and
whether it is backed by the manual, by a measurement (whose, which version),
or only by reading so far. A claim that the manual and a measurement disagree
on goes in this table and in section 9.

## Callouts (use only these two)

- **Lỗi hay gặp** (`.note`): a mistake the learner actually made or that
  interviews probe. State the mistake, why it breaks, and the rule that
  prevents it. Placed inline in section 2 or 3, summarised in section 7.
- **Góc nhìn senior** (`.senior`): what separates a senior answer: cost,
  trade-offs, how to measure. Mostly in section 6.

Do not add other callout types or decorative boxes.

## Writing rules

- Vietnamese prose, English technical terms. Do not translate page, leaf,
  split, buffer pool, WAL, heap, latch.
- Sentence case everywhere. No all-caps labels, no eyebrows above headings.
- One idea per sentence. Prefer lists for 3+ parallel items.
- Use concrete values: `user_id = 42`, block `52344`, `shared hit=5 read=19`.
  Values in a trace must be consistent from step to step.
- Analogies are welcome when short (mục lục cuốn sách, bàn đọc thư viện) and
  placed before the mechanism, not instead of it.
- Name the engine whenever behavior differs. The lab is MySQL 8.4; use InnoDB
  first and PostgreSQL as the comparison.
- Button text says what happens: "Chèn", "Tìm", "Đặt lại", "Trước", "Tiếp".

## Writing for readability

Agreed with the author on 2026-10-20, after the first four Month 1 pages read
as dense and hard to follow. Accuracy is not enough; the reader has to get the
idea on the first pass. Apply these to every paragraph, step description and
recall answer.

1. **Explain a term before using it.** The first time a term appears on the
   page, say what it is in plain Vietnamese in the same sentence or the one
   before: "Redo log ghi liên tục, mỗi byte có một số thứ tự gọi là LSN." After
   that, use the term freely. If a term only appears once, prefer the plain
   words over the term.
2. **Main point first.** Open each `h3` and each step description with the
   takeaway in one plain sentence, then the mechanism. A reader who stops after
   the first sentence should still leave with the right idea.
3. **One action per sentence.** Do not chain four steps with commas. Split
   them, or make a numbered list. Aim for sentences under about 25 words.
4. **Write Vietnamese, not translated English.** Prefer active voice with a
   clear subject ("InnoDB đọc page lên", not "page được đọc lên bởi InnoDB").
   Avoid stacked relative clauses ("mà … nằm trên … trên …"). Replace literal
   calques with natural words; keep the English term in parentheses only when
   the reader will meet it in tools or docs.
5. **Concrete before abstract.** Give the example with real values first
   ("bảng có PRIMARY và 4 index thì…"), then the general rule.
6. **Say why it matters.** End a mechanism with what it changes for the
   reader: a cost, a symptom, a decision.

### Term list

Keep the same choice on every page. "Giải thích lần đầu" is what to say the
first time the term appears.

| Term | Keep as | Giải thích lần đầu |
|---|---|---|
| page | page | khối 16KB, đơn vị InnoDB đọc và ghi |
| leaf page | leaf page | page ở tầng dưới cùng của cây, nơi chứa entry thật |
| entry | entry | một dòng trong index: giá trị cột cộng PK |
| buffer pool | buffer pool | vùng RAM InnoDB giữ page để khỏi đọc disk |
| dirty page | page đã sửa nhưng chưa ghi xuống disk | (không dùng "page bẩn" trơn; nếu cần thuật ngữ thì "dirty page") |
| split | tách page (split) | page đầy, InnoDB chia nó thành hai |
| redo log | redo log | nhật ký ghi lại mọi thay đổi trên page, dùng để làm lại sau sự cố |
| undo log | undo log | nơi giữ bản cũ của row, dùng để rollback và cho câu đọc cũ |
| LSN | LSN | số thứ tự của từng byte trong redo log |
| checkpoint | checkpoint | mốc trên redo log: mọi thay đổi trước mốc đã nằm trong file dữ liệu |
| purge | purge | thread nền dọn bản cũ và row đã đánh dấu xoá khi không ai cần nữa |
| delete-mark | đánh dấu xoá | entry vẫn còn đó nhưng được đánh dấu là đã xoá |
| read view | read view (ảnh chụp) | danh sách transaction đã commit "trong mắt" một câu đọc |
| made young | chuyển lên vùng new | page được coi là hay dùng |
| gap lock | gap lock | khoá khoảng trống giữa hai entry để không ai chèn vào |
| fsync | fsync | lệnh buộc hệ điều hành ghi hẳn xuống thiết bị |
