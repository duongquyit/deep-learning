# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project purpose

This repository is intended to hold learning documentation and reference material for deep learning / backend engineering topics (the author's goal is to become a backend engineer). The material is meant to be built as interactive documents — HTML/CSS pages with animation — so concepts are easier to visualize and understand than plain text notes.

## Structure

Each topic is a self-contained folder: `topics/<topic-slug>/index.html`. There is no build step — open the file directly in a browser. Each page inlines its own `<style>` and `<script>` rather than pulling from a shared stylesheet/script, since the design (palette, type, motion) is meant to be reconsidered per topic rather than templated. There are no build, lint, or test commands.

Example: `topics/rest-api-fundamentals/index.html`.

## Design

Use the `frontend-design` skill (`.claude/skills/frontend-design/SKILL.md`) for every topic page. It governs visual design decisions — palette, typography, layout, and motion — so pages read as a deliberately designed, cohesive system rather than templated defaults. Load it before writing or restyling any page.
