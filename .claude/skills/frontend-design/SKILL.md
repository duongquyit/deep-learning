---
name: frontend-design
description: Guidance for distinctive, intentional visual design when building new UI or reshaping an existing one. Helps with aesthetic direction, typography, and making choices that don't read as templated defaults. Routes dashboard and overview screens to the repo's house design system in .claude/docs/DESIGN_SYSTEM.md instead of designing them fresh.
license: Complete terms in LICENSE.txt
---

# Frontend Design

Approach this as the design lead at a design studio known for giving every client a distinct visual identity that is not mistaken for anyone else's. This client has already rejected proposals that felt cliché or templated, and is paying for a distinctive point of view: make deliberate, opinionated choices about palette, typography, and layout that are specific to this brief, and take aesthetic risk if justified.

## First: which kind of screen is this?

This repo has two kinds of screen, and they get opposite treatment. Decide which one you're building **before** designing anything.

**Dashboard-shaped — follow the house system, don't invent.** A screen that surveys or tracks many items rather than teaching one concept end to end: `roadmap.html`, `index.html`, and anything new that summarizes a program, a log, or a dataset. These already share one visual identity, and a second identity in this slot is a defect, not a point of view. Read [`.claude/docs/DESIGN_SYSTEM.md`](../../docs/DESIGN_SYSTEM.md) and build to it: its tokens (§2), shell and breakpoints (§3), component inventory (§4), interaction rules (§5), and content rules (§6) are binding. Skip the two-pass brainstorm below — the plan already exists. The sections on writing, restraint, and self-critique still apply.

Reuse what's there rather than adding to it. The four `grad-*` icon-badge gradients are the whole palette for badges; a fifth hue is what turns "varied but controlled" into sprawl. Same for the two shadow recipes and the three radii — depth comes from picking the right one, not from a new value. If a genuinely new component is needed, build it from the existing card chrome and then add it to §4, so the file keeps describing what's actually shipped.

**Topic lesson pages — follow the topic-page house style, don't invent.** Every `topics/<slug>/index.html` uses the style of the first topic, `topics/btree-index-internals/index.html`, written down in [`.claude/skills/topic-page/references/style.md`](../topic-page/references/style.md): Instrument Sans and JetBrains Mono, the grid-paper background, the type scale, frame and callout chrome, and one shared state palette. The author asked for this on 2026-10-19 after three pages had drifted into three looks; consistency between lessons matters more here than a fresh identity per topic. Copy the tokens and base CSS from that file, skip the two-pass brainstorm below, and spend the design effort on the widgets: what each one shows, how its state reads at a glance, how it behaves at 390px. `DESIGN_SYSTEM.md` does not apply to lesson pages either; its violet/pink dark theme is the dashboard's.

The sections below on writing, restraint, motion and self-critique still apply to both kinds of screen. The sections on choosing palette and type apply only to a genuinely new kind of screen that is neither a dashboard nor a lesson page.

If a screen sits between the two, ask rather than guess: the cost of wrongly forking either identity is high.

## Ground your designs in the subject matter

If the brief does not identify what the product or subject matter is, identify it yourself before designing, and confirm with the client. You can come up with one concrete subject, the design's audience, and the design's primary job, as a proposal. If there's any information in your memory about the client's preferences or context about what they're building, use that as a hint. The subject's industry, subject matter, materials, and vernacular are where distinctive visual choices come from — a design for a toy for girls aged 8–11 will be very aesthetically different from a dashboard for financial analysts. Build with the brief's real content and subject matter throughout.

## Design principles

For web designs, the hero is the first thing viewers will see. Open with the most characteristic thing in the subject's world, in the form that is most appropriate: a headline, an image, an animation, a live demo, an interactive moment, or other treatments. Be deliberate with your choice: a big number with a small label, supporting stats, and a gradient accent is the default treatment, so only use it if that's truly the best option.

Typography carries the personality of the page. You don't need a different typeface for display or headline text and body content: use one family or two, and if two, make them clearly distinct.

Choose your typefaces deliberately, not the default families you would reach for on any other project, and set a clear type scale following the default guidance of The Elements of Typographic Style with intentional weights, widths, and spacing. When type is used as a headline or visual element, use the type treatment itself as an active part of the design, not a neutral delivery vehicle for the content.

Default to line lengths of less than 80 characters. Serif typefaces can have slightly longer line lengths; give serif body text slightly more line-height than a sans-serif.

Avoid these default typographic treatments; they are the commonest tells of a generated page:
- Accenting just a single word or phrase in a headline, like putting one word in italic/bold or a different color.
- Using all caps for labels.
- Adding unnecessary typographic labels above content.

Visual structure is information. Structural devices like outlines, borders, numbering, eyebrows, dividers, labels, etc., encode useful information about the content rather than decorate it. Many generic designs use numbered markers (01 / 02 / 03), but that's only appropriate if the content actually is a sequence — like a stepped process or a timeline. Before adding numbered markers, check the content really is a sequence.

Use non-user-triggered motion sparingly and deliberately, only to draw attention. A single orchestrated moment — one page-load sequence or one reveal — lands better than scattered effects; fade-and-slide-up entrances on each section and hover transitions on every card are the generic default and read as AI-generated. Motion that answers a person's action (opening, expanding, confirming) is welcome when it shows what changed.

Consider written content carefully. Often a design brief may not contain real content, and it's up to you to come up with copy and placeholder content. Copy can make a design feel as templated as the design itself. See the below section on writing for more guidance.

## Process: plan, review against the brief, build, critique

For calibration, AI-generated design right now clusters around some traits:
1. a warm cream background (near #F4F1EA) with a high-contrast serif display and a terracotta or warm-clay accent (often near #D97757 — Anthropic's own Claude-interaction accent, so on a user's brief it reads as a tell);
2. a near-black background with a single bright acid-green or vermilion accent;
3. a broadsheet-style layout with hairline rules, zero border-radius, and dense newspaper-like columns;
4. the SaaS-card kit: content chopped into identical rounded cards, one border-radius on everything regardless of hierarchy, the same soft grey shadow (rgba(0,0,0,.1)) under each, and gradient washes as decoration;
5. template chrome that appears whatever the subject: a tracked-out ALL-CAPS eyebrow label above every heading; meta strings joined with middle dots ('A · B · C'); labels built as 'WORD — fragment' with a spaced em dash; tinted near-black (#0B0B0B, #111) standing in for black; a monospace face for small data labels; a '→' appended to link and button text.

Two notes on how this list meets the house system. Trait 4 describes the dashboard system's own ingredients — rounded cards, gradient accents, a dark panel — so read it as a warning about *undifferentiated* use of them, not a reason to re-style `roadmap.html` or `index.html`. What keeps those pages out of trait 4 is that the radii are tiered by element (§2), there are exactly two shadow recipes rather than one flat drop on everything, and the gradients are a fixed four-way badge cycle carrying card identity rather than decorative washes. Hold that line when extending them. Trait 5's tells, meanwhile, are already law for dashboards: §6 bans middle-dot meta-joins, trailing `→` glyphs, and ALL-CAPS eyebrows outright, and §2 confines monospace to the `[ ]`/`[~]`/`[x]`/`[!]` status marks, where it's literal notation from the source markdown rather than a small-data-label affectation.

All traits are legitimate for some briefs, but they are defaults rather than choices, and they appear regardless of subject. Where the brief pins down a visual direction, follow it exactly — the brief's own words always win, including when it asks for one of these looks. Where it leaves an axis free, don't spend that freedom on one of these defaults. As with a hired human designer, there's often a careful balance between doing what you're good at and taking each project as a chance to experiment and learn.

Work in two passes. First, brainstorm a short design plan based on the client's design brief: create a compact token system with color, type, layout, and principles.
- Color: describe the core base palette as 4–6 named hex values.
- Type: the typefaces and their roles.
- Layout: a layout concept, using one-sentence prose descriptions and ASCII wireframes to ideate and compare. Include alignment guidance; should the content be left aligned, center aligned, justified?
- Principles: the high-level guidance for what makes this page unique.

Then review that plan against the brief before building: if any part of it reads like the generic default you would produce for any similar page (work through a similar prompt to see if you arrive somewhere similar) rather than a choice made for this specific brief — revise that part, say what you changed and why. Only after you've confirmed the relative uniqueness of your design plan should you start to write the code, following the revised plan.

When writing the code, be careful of structuring your CSS selector specificities. It's easy to generate CSS classes that cancel each other out (especially with a type-based selector like .section and an element-based selector like .cta). This can happen often with padding/margin between sections.

## Restraint and self-critique

Spend your boldness in one place. Let one element be the memorable thing, keep everything around it quiet and disciplined, and cut any decoration that does not serve the brief. Build to a quality floor without announcing it: responsive down to mobile, visible keyboard focus, reduced motion respected, visually accessible, harmonious color palettes. Critique your own work as you build, taking screenshots to review if your environment supports it — a picture is worth 1000 tokens. Consider Chanel's advice: before leaving the house, take a look in the mirror and remove one accessory. Human creatives have memory and always try to do something new, so if you have a space to quickly jot down notes about what you've tried, it can help you in future passes.

## More on writing in design

Words appear in a design for one reason: to make it easier to understand and use. They are design content, not decoration. Bring the same intentionality and minimalism to copywriting that you would bring to spacing and color. Before writing anything, ask what the design needs to say, and how it can best be said to help the person navigate the experience.

Write from the end user's perspective. Name things by what users will understand in simple language, not by how the system is built. A user manages notifications, not webhook config. Describe what something is or does in plain terms rather than selling it. Being specific and legible to new users is always better than being clever.

Use active voice as default. A CTA says exactly what happens when it is used: "Save changes," not "Submit." An action keeps the same name through the whole flow, so the button that says "Publish" produces a toast that says "Published." The vocabulary of an interface is the signposting for someone navigating the product. Cohesion and consistency are how people learn their way around.

Never fabricate a number to fill a slot. A trend pill with no time series behind it, a percentage nobody measured, or a sparkline drawn from nothing is a lie the layout told you to write. Use a short contextual phrase instead ("opens in 5 days", "none yet", "ahead of plan"), or cut the element. On dashboard screens this is `DESIGN_SYSTEM.md` §6 and non-negotiable: every value traces to `ROADMAP.md`, `LEARNING_LOG.md`, or `TECHNICAL_GROWTH.md`, and is counted from the page's own content at load where it can be, so the summary can't drift from what it summarizes.

Treat failure and emptiness as moments for direction, not mood. Explain what went wrong and how to fix it, in the interface's voice rather than a person's. Errors don't apologize, and they are never vague about what happened. An empty screen is an invitation to act.

Keep the tone conversational: plain verbs, sentence case, no filler, with tone matched to the brand and the audience. Let each written element do exactly one job.
