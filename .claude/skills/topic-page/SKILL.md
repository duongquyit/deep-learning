---
name: topic-page
description: Build or extend an interactive learning page in topics/<slug>/index.html from a study session or topic. Use whenever the user asks to turn a lesson, conversation, or concept into a topic page, add a section or widget to one, or review one against the repo's conventions.
---

# Topic page

A topic page is a self-contained `topics/<slug>/index.html` that teaches one
backend concept the way a mentor would: short explanation, then a widget the
reader drives, then the takeaway. The reference implementation is
`topics/btree-index-internals/index.html`. Read it before building a new page.

This skill covers content, structure and interaction. Visual identity (palette,
type, layout mood) is NOT fixed here: load the `frontend-design` skill for that
and choose a new identity per topic, as CLAUDE.md requires.

## Workflow

1. **Gather the material.** Source is usually a mentor conversation. Collect
   every concept, example, number, correction and exercise from it. Corrections
   the learner needed ("you forgot the parent", "INCLUDE needs id too") are the
   most valuable content; keep them.
2. **Outline as a learning sequence.** Order sections the way the concept is
   learned, from "what/where" to "how it works inside" to "what it costs" to
   "how a senior reasons about it". Numbered section markers are allowed only
   because the sections really are a sequence. See `references/content.md`.
3. **Pick one widget per mechanism.** For each section ask: what moves or
   changes here? That is the widget. Use the patterns in
   `references/widgets.md` (stepper, simulator, playground, calculator, static
   figure). A table or list is enough when nothing moves.
4. **Choose the visual identity.** Load `frontend-design`, write the short
   token plan (colors, type, layout, principles), review it against the
   generic defaults listed there, then build.
5. **Build in one file.** Inline `<style>` and `<script>`, no frameworks, no
   build step. Fonts from Google Fonts are fine; everything else inline.
6. **Verify.** Run `scripts/check_page.py` (below) and look at the
   screenshots. Fix every JS error, stuck stepper and overflow before
   committing.
7. **Commit** as `Add interactive <topic> topic` with a body listing the
   sections.

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
  inactive. The hues are chosen per topic; the mapping is fixed per page and
  explained in a one-line legend near the first widget.
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

- `references/content.md`: section anatomy, callouts, exercises, writing rules.
- `references/widgets.md`: widget patterns, the stepper contract, SVG helper
  conventions, copy-ready helper code.
- `scripts/check_page.py`: automated page check.
