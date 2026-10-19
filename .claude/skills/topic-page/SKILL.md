---
name: topic-page
description: Build or extend an interactive learning page in topics/<slug>/index.html from a study session or topic. Use whenever the user asks to turn a lesson, conversation, or concept into a topic page, add a section or widget to one, or review one against the repo's conventions.
---

# Topic page

A topic page is a self-contained `topics/<slug>/index.html` that teaches one
backend concept the way a mentor would: short explanation, then a widget the
reader drives, then the takeaway. The reference implementation is
`topics/btree-index-internals/index.html`. Read it before building a new page.

This skill covers content, structure, interaction and the visual style. All
topic pages share one style, the style of the first topic, written down in
`references/style.md`. Do not design a new palette, font or layout per topic.

## Workflow

1. **Gather the material.** Source is usually a mentor conversation. Collect
   every concept, example, number, correction and exercise from it. Corrections
   the learner needed ("you forgot the parent", "INCLUDE needs id too") are the
   most valuable content; keep them.
2. **Fill the fixed document structure.** Every page has the same hero brief
   and the same ten sections in the same order: Bản chất vấn đề, Cơ chế hoạt
   động, Vì sao thiết kế như vậy, Ví dụ, Thí nghiệm, Ảnh hưởng khi chạy
   production, Hiểu lầm thường gặp, Câu hỏi ôn tập, Câu hỏi còn mở, Tài liệu
   tham khảo. What goes in each is in `references/content.md`. Sort the
   gathered material into them before writing anything.
3. **Pick one widget per mechanism.** For each section ask: what moves or
   changes here? That is the widget. Use the patterns in
   `references/widgets.md` (stepper, simulator, playground, calculator, static
   figure). A table or list is enough when nothing moves.
4. **Apply the house style.** Copy the fonts, tokens and base CSS from
   `references/style.md` as they are. Then decide which state colors from the
   shared palette the page needs and what each one means on this page, and
   write the one-line legend.
5. **Build in one file.** Inline `<style>` and `<script>`, no frameworks, no
   build step. Fonts from Google Fonts are fine; everything else inline.
6. **Verify.** Run `scripts/check_page.py` (below) and look at the
   screenshots. Fix every JS error, stuck stepper and overflow before
   committing.
7. **Commit** as `Add interactive <topic> topic` with a body listing the
   widgets, together with the `prediction.md` templates for section 5 and the
   log entry and roadmap mark that CLAUDE.md requires.

## Non-negotiables

- **Accuracy first.** Every number must be realistic and internally
  consistent (counters in a trace must add up; tree heights must match
  fan-out). Name the engine when behavior differs (PostgreSQL vs InnoDB).
  If a fact was stated wrongly during the lesson, the page carries the
  corrected version.
- **Mechanism over decoration.** A widget must show the actual mechanism
  (which page is touched, what moves, what gets written), not an
  illustration of the idea.
- **Semantic state colors.** Within a page, each color means one state and
  never changes meaning. Define them as CSS tokens. Typical states:
  structure, data/row, written/touched, miss/error, current path/search,
  inactive. The hues come from the shared palette in `references/style.md`,
  never new hex values; the mapping is fixed per page and explained in a
  one-line legend near the first widget.
- **Same style as every other topic page.** Fonts, background, type scale,
  frame, button and callout chrome come from `references/style.md`. Restyling
  is done there and applied to all pages at once.
- **Accessible by default.** Light and dark via `prefers-color-scheme`,
  visible `:focus-visible`, steppers operable with buttons and arrow keys,
  `aria-live` on step descriptions and logs, `role="img"` plus a label on
  every SVG, `prefers-reduced-motion` respected, no horizontal scroll at
  390px.
- **Copy in Vietnamese**, technical terms kept in English (page, split, leaf,
  buffer pool, WAL). Sentence case, plain verbs, short paragraphs. See
  `references/content.md`.

## Checking a page

```bash
python3 .claude/skills/topic-page/scripts/check_page.py topics/<slug>/index.html --out <scratch-dir>
```

It loads the page in headless Chromium at desktop and mobile widths, clicks
every stepper to its last step, presses every other button once, and reports:
JS errors, steppers whose description goes empty, horizontal overflow on
mobile, SVGs without an accessible name, and buttons without text. It writes
`desktop.png`, `mobile.png` and one screenshot per widget frame to `--out`.
Exit code 1 means something must be fixed. Font loading failures are ignored
(the sandbox may have no network).

Then open the screenshots and critique them: overlapping text, labels running
outside boxes, empty regions, a widget whose current state is unclear.

## Files

- `references/style.md`: the shared fonts, tokens, base CSS and markup for every topic page.
- `references/content.md`: section anatomy, callouts, exercises, writing rules.
- `references/widgets.md`: widget patterns, the stepper contract, SVG helper
  conventions, copy-ready helper code.
- `scripts/check_page.py`: automated page check.
