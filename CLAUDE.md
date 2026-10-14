# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project purpose

This repository is intended to hold learning documentation and reference material for deep learning / backend engineering topics (the author's goal is to become a backend engineer). The material is meant to be built as interactive documents — HTML/CSS pages with animation — so concepts are easier to visualize and understand than plain text notes.

## Structure

Each topic is a self-contained folder: `topics/<topic-slug>/index.html`. There is no build step — open the file directly in a browser. Each page inlines its own `<style>` and `<script>` rather than pulling from a shared stylesheet/script, since the design (palette, type, motion) is meant to be reconsidered per topic rather than templated. There are no build or lint commands.

Reference implementation: `topics/btree-index-internals/index.html`.

## Building a page

Use the `topic-page` skill (`.claude/skills/topic-page/SKILL.md`) whenever creating, extending, or reviewing a topic page. It defines the workflow (lesson → learning-order outline → one widget per mechanism → verify), the content conventions (Vietnamese copy, callouts, exercises), and the widget patterns (stepper, simulator, playground, calculator, static figure) with copy-ready helper code.

Before committing a page, run its check and review the screenshots:

```bash
python3 .claude/skills/topic-page/scripts/check_page.py topics/<slug>/index.html --out <scratch-dir>
```

## Design

Use the `frontend-design` skill (`.claude/skills/frontend-design/SKILL.md`) for every topic page. It governs visual design decisions — palette, typography, layout, and motion — so pages read as a deliberately designed, cohesive system rather than templated defaults. Load it before writing or restyling any page. The `topic-page` skill fixes structure and interaction, not the visual identity.
