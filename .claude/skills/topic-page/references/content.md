# Content conventions

Every topic page follows one fixed document structure, agreed with the author
on 2026-10-19. The sections, their order and their headings are the same on
every page, so a reader always knows where to look, and so recall, open
questions and experiments can be tracked across topics.

## Document structure

Eleven parts, in this order. Parts 1 to 10 are numbered sections (`01` to
`10`) with exactly these Vietnamese headings; the topic goes in the text, not
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
| 9 | Câu hỏi còn mở | Open questions with status |
| 10 | Tài liệu tham khảo | Sources, and how far each claim has been verified |

The TOC lists the ten numbered sections. A section may have `h3` subsections;
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

### 9. Câu hỏi còn mở

What is not understood yet or needs research. Each item has the same number
as in Open questions of `LEARNING_LOG.md` (the log is the source of truth),
a status (`mở`, `đã trả lời một phần`, `đã trả lời`, `bỏ`) and, once
answered, by what (an experiment, a manual section) and when. Change the
status in the log and on the page in the same commit.

### 10. Tài liệu tham khảo

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
