# Content conventions

## Page anatomy

1. **Hero.** A plain headline naming the topic and its scope ("từ câu query tới
   từng page trong RAM"), a one-paragraph lede saying what the reader will be
   able to explain afterwards, then the topic's most characteristic
   interactive thing (in the B+tree page: a playground where the reader
   inserts keys and watches splits). No stat blocks, no marketing copy.
2. **Numbered sections in learning order.** Typical arc:
   - Where/when it is used (tables of engines, use cases, anti-cases)
   - The unit and the numbers (sizes, limits, a calculator)
   - How it changes (the core mechanism, a stepper)
   - What it looks like inside (layout, a stepper)
   - How it lives in memory / at runtime
   - A full end-to-end trace with real numbers
   - Cost and trade-offs (what makes it slow, what fixes it, what that fix costs)
   - Related structure the learner asked about along the way
   - Senior checklist, exercises, check questions
3. **Sticky table of contents** on desktop, a collapsible one on mobile.
   Highlight the section in view.

## Section anatomy

Each section follows: short explanation (2 to 5 short paragraphs or a list),
then the widget, then the takeaway in one or two sentences. Tables for
comparisons across engines or options. Code blocks for real SQL, config and
`EXPLAIN` output the reader can run.

## Callouts (use only these two)

- **Lỗi hay gặp** (warning color): a mistake the learner actually made or that
  interviews probe. State the mistake, why it breaks, and the rule that
  prevents it. Example: forgetting to update the parent after a split.
- **Góc nhìn senior** (outlined box): what separates a senior answer: cost,
  trade-offs, how to measure. Example: random UUIDv4 keys make leaves 50 to
  70% full; covering indexes cost write amplification.

Do not add other callout types or decorative boxes.

## Exercises and check questions

End the page with:

- **Bài tập thực hành**: hands-on tasks with concrete sizes and the exact
  command or metric to compare (`EXPLAIN (ANALYZE, BUFFERS)`,
  `pg_relation_size`). Each in a `<details>`.
- **Câu hỏi kiểm tra**: the questions asked during the lesson, one per
  `<details>`, question only. Answers stay out of the page so it can be used
  for self-testing.

## Writing rules

- Vietnamese prose, English technical terms. Do not translate page, leaf,
  split, buffer pool, WAL, heap, latch.
- Sentence case everywhere. No all-caps labels, no eyebrows above headings.
- One idea per sentence. Prefer lists for 3+ parallel items.
- Use concrete values: `user_id = 42`, block `52344`, `shared hit=5 read=19`.
  Values in a trace must be consistent from step to step.
- Analogies are welcome when short (mục lục cuốn sách, bàn đọc thư viện) and
  placed before the mechanism, not instead of it.
- Name the engine whenever behavior differs. Default to PostgreSQL and add the
  InnoDB contrast in a table.
- Button text says what happens: "Chèn", "Tìm", "Đặt lại", "Trước", "Tiếp".
