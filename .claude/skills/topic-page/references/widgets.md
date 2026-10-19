# Widget patterns

Pick the pattern by what the reader needs to see change.

| Pattern | Use when | Example in btree-index-internals |
|---|---|---|
| Stepper | A fixed sequence of states the reader walks through | Root split, slotted page, query trace |
| Simulator | Same rules, reader chooses the inputs, state accumulates | Buffer pool clock-sweep |
| Playground | Reader types arbitrary input into a real algorithm | B+tree insert/search |
| Calculator | A formula whose output depends on a few parameters | Fan-out and tree height |
| Static figure | A layout or comparison with nothing to step through | Index Only Scan vs Index Scan, TOAST |

Every widget sits in a **frame**: a bordered container with a header strip
(title on the left, small status such as "bước 3 / 9" on the right) and a body.

## Stepper contract

The check script relies on this markup, so keep it:

- Root: `.frame` with an `id`, `tabindex="0"`, arrow keys move steps.
- Title of the current step: `.st-t`.
- Description: `.st-d` inside an element with `aria-live="polite"`. It must
  never be empty.
- Optional code for the step: a `<pre>` that is `hidden` when the step has
  no code.
- Navigation: `button[data-d="-1"]` (Trước) and `button[data-d="1"]` (Tiếp).
  Disable them at the ends instead of wrapping around.

Step data is an array of plain objects. Use these keys consistently:
`t` title, `d` description, `c` code text (only code; never reuse `c` for a
color or class), plus widget-specific keys for state (`hl` highlighted ids,
`k` state class, counters). Reusing `c` for a class once printed "hit" into
the code box; that is why it is reserved.

Each step should change one thing. Twelve small steps beat five crowded ones.
For traces, show running counters next to the SVG (hit / read / rows) and make
the final step show the real tool output (e.g. `EXPLAIN`) whose numbers match
the counters.

## Simulator rules

- Buttons for the inputs (e.g. one per query), plus "Đặt lại".
- Show the state as small panels (frames, slots) and the totals as stat tiles.
- An event log with `aria-live="polite"`, newest first, at most ~7 lines.
- Animate multi-step actions with a short delay, set to 0 when
  `prefers-reduced-motion` is on. Ignore clicks while an action runs.

## Playground rules

- Implement the real algorithm, not a scripted path. Validate input and say
  what is accepted ("Nhập một số nguyên từ 0 đến 999").
- Start from the exact example used in the lesson and offer a button that
  replays the lesson's sequence one step at a time.
- Highlight what the last action touched with the state colors and log what
  happened in words, including the cost (pages read or written).

## SVG conventions

- `viewBox` width 680 for in-flow widgets, `width="100%"`, height from content.
- Colors come only from CSS classes bound to the page's tokens, never inline
  hex, so dark mode works.
- State classes on a `<g class="n STATE">` wrapping a rect and its text:
  `struct`, `row`, `hot` (written/touched), `miss`, `hit`, `info` (current
  path), `dim` (inactive). Rename if the topic needs other states, but keep one
  meaning per class.
- Edges: `.edge`, with `.on` (active path), `.hot`, `.miss` modifiers.
- Text at least 12px. Keep labels inside their boxes; size boxes from content.

## Helper code

Copy these into each page's `<script>` (pages do not share files). Adjust the
CSS class names to the page's tokens.

```js
const DEFS=`<defs><marker id="arw" viewBox="0 0 10 10" refX="8" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse"><path d="M2 1L8 5L2 9" fill="none" stroke="context-stroke" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/></marker></defs>`;
// Box with a main label and optional sub label; start=true left-aligns.
function B(x,y,w,h,cls,t,sub,start){
  const tx=start?x+10:x+w/2, an=start?'start':'middle';
  return `<g class="n ${cls||''}"><rect x="${x}" y="${y}" width="${w}" height="${h}" rx="5"/>`+
  `<text class="tb" x="${tx}" y="${y+(sub?h/2-8:h/2)}" text-anchor="${an}" dominant-baseline="central">${t}</text>`+
  (sub?`<text class="ts" x="${tx}" y="${y+h/2+10}" text-anchor="${an}" dominant-baseline="central">${sub}</text>`:'')+`</g>`;
}
const L=(x1,y1,x2,y2,cls)=>`<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" class="edge ${cls||''}"/>`;
const A=(d,cls)=>`<path d="${d}" class="edge ${cls||''}" marker-end="url(#arw)"/>`;
const T=(x,y,t,anchor,cls)=>`<text class="${cls||'lbl'}" x="${x}" y="${y}" text-anchor="${anchor||'start'}">${t}</text>`;
const esc=s=>String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;');

// Mounts a stepper into <div class="frame" id="ID"></div>.
// opts: {title, vb, steps, draw(step,i) -> svg string, after?(step,el), extra? html above svg}
function stepper(id,{title,vb,steps,draw,after,extra}){
  const el=document.getElementById(id);
  el.innerHTML=`<div class="ph"><strong>${title}</strong><span class="meta"></span></div><div class="bd">
  <h4 class="st-t"></h4>${extra||''}
  <svg viewBox="${vb}" role="img"></svg>
  <div class="desc" aria-live="polite"><div class="st-d"></div><pre hidden></pre></div>
  <div class="nav"><button data-d="-1">Trước</button><button data-d="1" class="primary">Tiếp</button></div></div>`;
  const svg=el.querySelector('svg'),t=el.querySelector('.st-t'),d=el.querySelector('.st-d'),pre=el.querySelector('pre'),meta=el.querySelector('.meta');
  const [pv,nx]=el.querySelectorAll('.nav button');let i=0;
  function render(){const s=steps[i];svg.innerHTML=DEFS+draw(s,i);svg.setAttribute('aria-label',s.t);t.textContent=s.t;d.textContent=s.d;
    pre.hidden=!s.c;pre.textContent=s.c||'';meta.textContent=`bước ${i+1} / ${steps.length}`;pv.disabled=i===0;nx.disabled=i===steps.length-1;after&&after(s,el);}
  function go(k){i=Math.max(0,Math.min(steps.length-1,i+k));render();}
  pv.onclick=()=>go(-1);nx.onclick=()=>go(1);
  el.tabIndex=0;el.addEventListener('keydown',e=>{if(e.key==='ArrowRight')go(1);if(e.key==='ArrowLeft')go(-1);});
  render();
}
```

Minimal CSS the helpers expect (tokens come from `style.md`):

```css
.n rect{fill:var(--surface);stroke:var(--rule-strong)}
.n text{fill:var(--ink)}
.n.struct rect{fill:var(--struct-bg);stroke:var(--struct)} .n.struct text{fill:var(--struct)}
/* ...one rule pair per state class... */
.edge{stroke:var(--rule-strong);stroke-width:1.2;fill:none}
.edge.on{stroke:var(--struct);stroke-width:2.6}
```
