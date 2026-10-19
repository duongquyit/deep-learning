# Dashboard Design System

> Extracted from `roadmap.html` as built on 2026-10-14, which follows the reference screenshot `.claude/docs/theme.jpeg` (a dark violet/pink/blue SaaS analytics dashboard). This is the house style for **dashboard/overview-style screens** in this repo — pages that summarize state across many items (a program, a log, a dataset). `roadmap.html` and the topic directory `index.html` both already build on these tokens; a new dashboard screen joins them rather than starting its own identity.
>
> It does **not** apply to `topics/<slug>/index.html` lesson pages. Those share a separate house style of their own, defined in `.claude/skills/topic-page/references/style.md`. Use this file only when the new screen is dashboard-shaped: it surveys or tracks something, rather than teaching one concept end to end.

## 1. Summary of the current design

`roadmap.html` renders `ROADMAP.md` as an app-shell dashboard: a fixed sidebar (brand + scroll-spy nav), a sticky top bar (live search, a status pill), and a main column of a stat-card row, a program-timeline chart, a sessions list, three mini stat cards, six collapsible month cards, and a finish-line card. Visually it reproduces the reference screenshot closely — near-black panel, violet/pink/blue gradient icon badges, rounded cards, soft shadows — but every element borrowed from the reference was re-grounded in real content before shipping:

- The reference's decorative search bar became a real filter over weekly-plan and deliverable rows.
- The reference's "Dashboard" sidebar highlight became a working `IntersectionObserver` scroll-spy over the page's own sections.
- The reference's revenue/growth stat tiles became counts that are computed from the status marks already in the DOM (`[ ]`/`[x]`), so they can't drift from the content.
- The reference's performance chart became an SVG step chart of *planned vs. logged deliverables* — real cumulative data from the schedule, not a fabricated trend line.
- The reference's "Alex Morgan, Admin" avatar was dropped rather than invented; this program has one author, so the top-right slot holds a status pill instead.

The rules below generalize that pattern so the next dashboard-style screen matches without re-deriving it from scratch.

## 2. Tokens

### Color

| Token | Hex | Role |
|---|---|---|
| `--bg-0` | `#0A0812` | Page background, behind the shell |
| `--shell-bg` | `#0E0B16` | App-shell panel background |
| `--sidebar-bg` | `#110D1B` | Sidebar background |
| `--card-bg` | `#161220` | Default card surface |
| `--card-bg-2` | `#1C1729` | Inset surface inside a card (e.g. the `.scope` callout) |
| `--border` | `rgba(255,255,255,.08)` | Default hairline |
| `--border-strong` | `rgba(255,255,255,.16)` | Open/active state border |
| `--text-0` | `#F3F1F7` | Headings, primary values |
| `--text-1` | `#B9B3C7` | Body text |
| `--text-2` | `#7D7791` | Muted/meta text |
| `--violet` / `--violet-2` | `#7C3AED` / `#A78BFA` | Primary accent, "planned" series |
| `--pink` / `--pink-2` | `#DB2777` / `#F472B6` | Secondary accent, "logged/actual" series |
| `--blue` / `--blue-2` | `#3B82F6` / `#60A5FA` | Third badge hue |
| `--rose` / `--rose-2` | `#F43F5E` / `#FB7185` | Fourth badge hue |
| `--green` / `--green-tint` | `#22C55E` / `#4ADE80` | Done / positive |
| `--amber` / `--amber-tint` | `#F59E0B` / `#FBBF24` | In progress |

Icon-badge gradients cycle through exactly four combinations — `grad-a` (rose), `grad-b` (violet), `grad-c` (blue), `grad-d` (violet→pink) — assigned round-robin to stat cards and month indices. Reuse these four rather than inventing a fifth hue; that's what keeps the "varied but controlled" multi-accent look instead of sprawling into arbitrary colors per new card.

### Type

- UI, headings, and body: **Inter** (400/500/600/700/800).
- Status marks only (`[ ]`, `[~]`, `[x]`, `[!]`): **JetBrains Mono** 700, inside a pill (`.mark`). This is the one place monospace appears — it's literal notation carried over from `ROADMAP.md`'s own vocabulary, not a decorative label font. Don't extend mono to dates, counts, or anything else; that reads as the generic "monospace for small data labels" tell.
- Stat values use `font-variant-numeric: tabular-nums` so digits don't jitter.

### Radius, shadow, spacing

- `--r-l: 18px` — cards (stat, chart, side, month, finish).
- `--r-m: 12px` — inputs, mini cards.
- `--r-s: 9px` — small insets (scope callout, sidebar nav items).
- Pills (`.mark`, `.trend`, `.pill-static`, `.tag-feeds`): `999px`.
- One shadow recipe per surface depth: cards use `0 10px 26px rgba(0,0,0,.28)`; the outer app-shell uses the louder `0 50px 140px rgba(124,58,237,.18), 0 20px 60px rgba(0,0,0,.55)`. Don't give every element its own shadow value — depth comes from which of these two a thing uses, not from a third.
- Card gaps: 16–18px. Section content padding: 32px desktop, 18px at ≤760px.

## 3. Layout shell

- `.app-shell`: sidebar + main, `max-width: 1360px`, centered, rounded 28px, the loud shadow above.
- Sidebar: fixed 252px, brand mark + scroll-spy nav + footer links pinned to the bottom with `margin-top: auto`.
- Main: sticky, blurred top bar (`backdrop-filter: blur(10px)`) containing search (functional) and a static status pill; content column below.
- Breakpoints: `980px` collapses stat/mini grids to fewer columns; `760px` flips the sidebar to a horizontal scrollable strip and removes the shell's outer margin/radius (full-bleed on mobile).

## 4. Components

- **Stat card** — gradient icon badge (38px, one of the four `grad-*`), label, tabular value with a `<small>` denominator, one contextual trend pill. The trend pill is text, never a fabricated percentage (see §6).
- **Chart card** — header (title + one-line subtitle + dot-legend), inline SVG, axis labels outside the SVG in a flex row. Hand-rolled SVG only; no charting library, consistent with the repo's no-build-step convention.
- **Side list card** — icon-badge + title + one-line meta + a small colored dot per row. Used for anything that's fundamentally a feed of events (here: logged sessions).
- **Mini card** — label + value header, then either a 6-bar mini bar chart or a 6-dot indicator underneath. Every bar/dot must encode a real per-item value (weeks, deliverable counts, presence/absence of a field) — never a decorative sparkline with no backing data.
- **Detail card** (`details.month-card`) — native `<details>/<summary>`, not a custom accordion: icon badge with the item's index, title + range, a status `.mark`, a rotating caret. Body content keeps the same internal rhythm (`.focus`, `.block`, `.scope`, `.aipractice`) regardless of which screen uses it.
- **Status mark** (`.mark`) — the bracket notation from the source markdown, restyled as a small pill, colored by state (not-started / progress / done / blocked). Carry this through verbatim wherever a screen renders something that also exists as a tracked item in a markdown file with the same `[ ]`/`[~]`/`[x]`/`[!]` convention.
- **Finish/ledger card** — same card chrome as the rest, used for a single terminal checklist (a destination, not a step in the sequence).

## 5. Interaction rules

1. **No decorative chrome.** If the reference screenshot has a search bar, notification list, or nav item, it ships wired to real behavior in this repo's version, or it doesn't ship. A non-functional search box is a worse default than no search box.
2. **Numbers are computed, not hand-typed, wherever they can be.** Stat cards and tallies read `data-kind` attributes off the marks already in the page and count them on load, so the dashboard can't silently drift from the content it's summarizing.
3. **One motion moment, if any.** The current build has no load animation beyond the browser's native `<details>` toggle and `scroll-behavior: smooth`. If a new screen adds one orchestrated reveal, gate it behind `@media (prefers-reduced-motion: reduce)` exactly like the rest of this repo's pages.
4. **Prefer native elements.** `<details>/<summary>` for disclosure, `<a>` for navigation, `<input>` for search — not custom JS widgets. Keyboard and screen-reader behavior come free that way.
5. **Visible focus.** `:focus-visible` outline in `--violet-2`, 2px, with offset — applies globally, not per component.

## 6. Content rules

- **Never fabricate a trend or percentage.** If there's no real time series behind a metric, use a short contextual phrase instead (`"opens in 5 days"`, `"none yet"`, `"ahead of plan"`) rather than inventing a `+N%`.
- **No middle-dot meta-joins** (`"A · B · C"`). Use plain sentences, separate elements, or a comma — the dot-chain is one of the most recognizable generic-AI-page tells and it's easy to slip back into when compressing metadata.
- **No arrow glyph appended to links or buttons** as a CTA flourish. An arrow used to show a real directional relationship between two pieces of content (e.g. "feeds Month 1") is fine as a word ("feeds"), not as a trailing `→`.
- **Sentence case labels**, never tracked-out ALL CAPS eyebrows.
- **Every number must trace to a source file.** If a metric can't be honestly derived from `ROADMAP.md` / `LEARNING_LOG.md` / `TECHNICAL_GROWTH.md`, cut the card rather than invent a placeholder value.

## 7. Known, intentional deviations from `theme.jpeg`

- No fake user identity in the top-right slot (the reference shows "Alex Morgan, Admin"). This program has one author — a status pill sits there instead of an invented persona.
- No revenue/growth-style metrics with invented percentages. Every stat card maps to a real, re-countable quantity.
- Typography is Inter + JetBrains Mono rather than whatever the reference screenshot used verbatim — close enough to read as the same product, not a pixel-matched clone.

---

**How this gets loaded.** The `frontend-design` skill (`.claude/skills/frontend-design/SKILL.md`) opens with a routing gate that sends dashboard-shaped screens here and sends `topics/<slug>/index.html` lesson pages to the topic-page house style, and `CLAUDE.md` points at that skill for both kinds of screen. So a session that loads the skill picks this file up without being told.

Keep that loop closed when this file changes: §4's component inventory is meant to describe what has actually shipped, so a new dashboard component gets added here in the same session it's built, and a token that stops being used gets removed. The skill defers to this file for tokens, components, and content rules — if they drift, the skill starts enforcing a system that no longer exists.
