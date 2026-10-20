# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project purpose

This repository is intended to hold learning documentation and reference material for deep learning / backend engineering topics (the author's goal is to become a backend engineer). The material is meant to be built as interactive documents — HTML/CSS pages with animation — so concepts are easier to visualize and understand than plain text notes.

## Structure

Each topic is a self-contained folder: `topics/<topic-slug>/index.html`. There is no build step — open the file directly in a browser. Each page inlines its own `<style>` and `<script>` rather than pulling from a shared stylesheet/script, so a page opens on its own from disk. All topic pages share one visual style; each page carries its own copy of it (see Design). There are no build or lint commands.

Reference implementation: `topics/btree-index-internals/index.html`.

## Building a page

Use the `topic-page` skill (`.claude/skills/topic-page/SKILL.md`) whenever creating, extending, or reviewing a topic page. It defines the workflow (lesson → fixed document structure → one widget per mechanism → verify), the document structure every topic follows (hero brief with goals, prerequisites and status; then core concept, mechanism, design reasons, examples, experiments, production implications, misconceptions, recall questions with answers, real-world cases with hidden senior answers, open questions, references — see `references/content.md`), the content conventions (Vietnamese copy, callouts), and the widget patterns (stepper, simulator, playground, calculator, static figure) with copy-ready helper code.

Before committing a page, run its check and review the screenshots:

```bash
python3 .claude/skills/topic-page/scripts/check_page.py topics/<slug>/index.html --out <scratch-dir>
```

## Research must close the loop

Research in this repo is not finished when the artifact looks good. Every research or study session — a new topic page, a substantial extension of an existing one, an experiment, or a deep investigation that produces no page at all — closes with **both** of these, in the same session as the work:

1. **A dated entry in [.claude/docs/LEARNING_LOG.md](.claude/docs/LEARNING_LOG.md)**, newest first, using the fields that file's header defines (topic and objective, output, what it covers, initial understanding, mistakes corrected, experiments and results, competency level, remaining questions, next step). Update the competency matrix rows the session touched, and move anything unresolved into Open questions.
2. **A mark in [.claude/docs/ROADMAP.md](.claude/docs/ROADMAP.md)** — tick the week, deliverable, or exit criterion the work advances, following that file's Progress marking rules. Work that was not on the plan goes in the Unplanned work table instead, with the month it feeds.

The two must agree. A roadmap `[x]` with no log entry behind it, or a log entry that advanced the plan without a mark, is a defect — fix it rather than leaving the next session to guess what actually happened.

3. **A clean `progress.py`**, run last, once the markdown is written:

```bash
python3 .claude/scripts/progress.py sync      # check, then regenerate .claude/docs/progress.json and roadmap.html
```

`check` enforces the rules above mechanically — `[x]` without a log entry in that
month, a session the roadmap never acknowledges, a mark dated in the future, a
competency row citing a session that does not exist, a Level 3+ claim without
`(prov.)`, weeks that do not tile their month, and **silent slippage**: calendar
weeks that passed with nothing marked `[~]`, `[x]` or `[!]`. It exits non-zero and
a pre-commit hook blocks the commit, so the three files cannot drift apart. Run
`check --today YYYY-MM-DD` to see what it will say on a future date.

Git does not version `.git/hooks`, so the hook needs installing once per clone:

```bash
ln -sf ../../.claude/scripts/pre-commit .git/hooks/pre-commit
```

`git commit --no-verify` bypasses it for a deliberate work-in-progress commit.

### Who owns which file

| File | Owner | Rule |
|---|---|---|
| [.claude/docs/ROADMAP.md](.claude/docs/ROADMAP.md) | written by hand | the plan and its marks — the only place progress is declared |
| [.claude/docs/LEARNING_LOG.md](.claude/docs/LEARNING_LOG.md) | written by hand | the evidence behind every mark |
| `.claude/docs/progress.json` | **generated** | never edit; `progress.py derive` overwrites it |
| [roadmap.html](roadmap.html) — prose and layout | written by hand | the Vietnamese copy and the design |
| [roadmap.html](roadmap.html) — marks, counts, dates, chart | **generated** | inside the `progress:begin`/`progress:end` block, plus everything the page computes from it at load time |

Never type a date, a count or a status directly into `roadmap.html`. It had three
hand-maintained copies of the program's state before this rule existed, and they
disagreed. The page computes the program day, the current week and the slippage
from the clock at load time, so it cannot go stale between runs of the script —
only the marks can, and that is exactly what `check` catches.

Three rules that govern what may be written:

- **Never record an experiment that was not run.** A simulation built from reading is a model, not an observation. Say so, and leave the experiment field empty if nothing was measured.
- **Never fill in what only the author knows.** Fields like "initial understanding" and "mistakes corrected" stay `TODO` unless the author stated it in the session. An empty field is honest; an invented one corrupts the baseline the whole program is measured against.
- **Level 3+ needs evidence beyond notes.** Reading and writing about a topic supports Level 2 at most. A measurement, an experiment, or real code is what raises it — mark levels `(prov.)` until then.

The program's own definitions of the competency levels, the session rules, and the evidence standard are in [.claude/docs/TECHNICAL_GROWTH.md](.claude/docs/TECHNICAL_GROWTH.md) Sections 9 and 11.

## Design

Use the `frontend-design` skill (`.claude/skills/frontend-design/SKILL.md`) before writing or restyling **any** page — topic pages and dashboard screens alike. It governs visual design decisions — palette, typography, layout, and motion — and opens by routing the two kinds of screen apart:

- **Dashboard/overview screens** (`roadmap.html`, `index.html`, anything new that summarizes a program, a log, or a dataset) follow the house system in [.claude/docs/DESIGN_SYSTEM.md](.claude/docs/DESIGN_SYSTEM.md) — fixed tokens, shell, components, and content rules. Don't design these fresh.
- **Topic lesson pages** (`topics/<slug>/index.html`) all share one style: the style of the first topic, `topics/btree-index-internals/index.html`. Fonts (Instrument Sans, JetBrains Mono), the light grid background and its dark counterpart, type scale, frame and button chrome, callouts and the shared state palette are written down copy-ready in [.claude/skills/topic-page/references/style.md](.claude/skills/topic-page/references/style.md). Do not pick a new palette, font or layout for a topic. `DESIGN_SYSTEM.md` does not apply to them.

The `topic-page` skill fixes structure, interaction and the shared style. When the style itself changes, change `style.md` and every existing topic page in the same commit, so the pages never drift apart again.
