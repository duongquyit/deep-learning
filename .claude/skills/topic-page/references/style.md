# House style for topic pages

Every topic page (`topics/<slug>/index.html`) uses one shared visual style: the
style of the first topic, `topics/btree-index-internals/index.html`. Same fonts,
same background, same type scale, same chrome for frames, buttons, callouts and
the table of contents. A reader moving from one lesson to the next should only
notice the content change.

Do not choose a new palette, font or layout per topic. What a topic decides is
which state colors from the shared palette it needs and what each one means on
that page (one meaning per color, stated in the legend).

Pages do not share files, so copy the two blocks below into the page's
`<style>` as they are, then add the page's widget CSS after them.

## Fonts

```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Instrument+Sans:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

Instrument Sans for everything, headings included. JetBrains Mono only for
code, SQL, `EXPLAIN` output, counters and section numbers.

## Tokens

The base tokens and the shared state palette. Copy the whole block, including
the colors the page does not use, so every page has the same names.

```css
:root{
  --paper:#F2F4F6; --surface:#FFFFFF; --ink:#18203A; --ink-2:#56607A; --ink-3:#8A93A8;
  --rule:#CCD3DD; --rule-strong:#8C96AB;
  --struct:#3446B8; --struct-bg:#E6E9FA;            /* cấu trúc index, chrome của trang */
  --row:#16795F;    --row-bg:#DDF2EA;               /* dữ liệu row thật */
  --hot:#9A5F00;    --hot-bg:#FCEFD2; --hot-line:#E3A21A;  /* bị ghi, bị chạm, bị lọc */
  --miss:#B5302B;   --miss-bg:#FBE1DF;              /* đọc từ disk, việc thừa, lỗi */
  --path:#0B7A8A;   --path-bg:#D8F1F3;              /* đường đi hoặc khoảng đang đọc */
  --key:#A8327A;    --key-bg:#F8E0EE;               /* con trỏ: PK, TID */
  --ram:#5B4BB0;    --ram-bg:#E7E3FA;               /* hit trong buffer pool */
  --grid:rgba(52,70,184,.06);
  --r-s:4px; --r-m:8px;
  --sans:"Instrument Sans",system-ui,sans-serif; --mono:"JetBrains Mono",ui-monospace,monospace;
}
@media (prefers-color-scheme:dark){:root{
  --paper:#0F1320; --surface:#171C2B; --ink:#E6E9F2; --ink-2:#A3ABC0; --ink-3:#6E7790;
  --rule:#2C3448; --rule-strong:#55607A;
  --struct:#97A3FF; --struct-bg:#232A55;
  --row:#5FD0AE;    --row-bg:#123A31;
  --hot:#F2BE5C;    --hot-bg:#3B2C0E; --hot-line:#E3A21A;
  --miss:#FF8A84;   --miss-bg:#3E1A1A;
  --path:#5ED3E0;   --path-bg:#113A40;
  --key:#F28DC4;    --key-bg:#3E1A2E;
  --ram:#B7A8FF;    --ram-bg:#2A2350;
  --grid:rgba(151,163,255,.05);
}}
```

The comments give each color's default meaning. A page may give a color a
different meaning when the topic needs it (the composite-index page uses `hot`
for "rejected inside the index"), as long as the legend says so and the color
keeps that one meaning across the whole page.

## Base CSS

```css
*{box-sizing:border-box}
[hidden]{display:none!important}
html{scroll-behavior:smooth}
@media (prefers-reduced-motion:reduce){html{scroll-behavior:auto}*{transition:none!important;animation:none!important}}
body{margin:0;color:var(--ink);font:400 17px/1.65 var(--sans);
  background-color:var(--paper);
  background-image:linear-gradient(var(--grid) 1px,transparent 1px),linear-gradient(90deg,var(--grid) 1px,transparent 1px);
  background-size:24px 24px}
a{color:var(--struct)}
:focus-visible{outline:2px solid var(--struct);outline-offset:2px}

/* layout */
.shell{display:grid;grid-template-columns:230px minmax(0,1fr);gap:56px;max-width:1180px;margin:0 auto;padding:0 32px}
nav.toc{position:sticky;top:0;align-self:start;height:100vh;padding:48px 0;overflow:auto}
nav.toc p{font-weight:600;margin:0 0 12px;font-size:15px}
nav.toc ol,.mobile-toc ol{list-style:none;margin:0;padding:0;counter-reset:s}
nav.toc li,.mobile-toc li{counter-increment:s;margin:0}
nav.toc a,.mobile-toc a{display:grid;grid-template-columns:28px 1fr;padding:5px 0;color:var(--ink-2);text-decoration:none;font-size:14.5px;line-height:1.4}
nav.toc a::before,.mobile-toc a::before{content:counter(s,decimal-leading-zero);font:500 12px/1.9 var(--mono);color:var(--ink-3)}
nav.toc a:hover,nav.toc a.on{color:var(--struct)}
main{min-width:0;padding:56px 0 120px}
.prose{max-width:720px}
section{padding-top:72px}
section>header{display:grid;grid-template-columns:auto 1fr;gap:0 18px;align-items:baseline;max-width:720px;margin-bottom:12px}
section>header .num{font:500 15px var(--mono);color:var(--struct);border:1.5px solid var(--struct);border-radius:var(--r-s);padding:2px 7px;transform:translateY(-4px)}
h1,h2,h3,h4{line-height:1.2;letter-spacing:-.015em;margin:0}
h1{font-size:clamp(2.3rem,5.4vw,3.9rem);font-weight:700;letter-spacing:-.03em;line-height:1.02;max-width:14ch;margin-bottom:20px}
.lede{font-size:19px;color:var(--ink-2);max-width:56ch;margin-bottom:28px}
h2{font-size:clamp(1.6rem,3vw,2.1rem);font-weight:650}
h3{font-size:1.2rem;font-weight:600;margin:36px 0 8px}
p{margin:0 0 14px}
ul,ol.list{margin:0 0 16px;padding-left:22px}
li{margin:4px 0}
code{font:0.88em var(--mono);background:var(--struct-bg);color:var(--ink);padding:1px 5px;border-radius:3px}
pre{font:13.5px/1.6 var(--mono);background:var(--surface);border:1px solid var(--rule);border-left:3px solid var(--struct);border-radius:var(--r-s);padding:14px 16px;overflow-x:auto;margin:0 0 18px;max-width:720px}
pre code{background:none;padding:0}
.tablewrap{overflow-x:auto;max-width:720px;margin:0 0 20px}
table{border-collapse:collapse;width:100%;max-width:720px;margin:0 0 20px;font-size:15px;background:var(--surface)}
.tablewrap table{margin:0;min-width:560px}
th,td{text-align:left;padding:9px 12px;border:1px solid var(--rule);vertical-align:top}
th{font-weight:600;background:var(--struct-bg)}

/* widget frame: styled like a page, header strip = page header */
.frame{background:var(--surface);border:1px solid var(--rule);border-radius:var(--r-m);margin:22px 0 28px;max-width:920px;overflow:hidden}
.frame>.ph{display:flex;flex-wrap:wrap;align-items:center;gap:6px 12px;padding:9px 16px;border-bottom:1px solid var(--rule);background:var(--struct-bg);font-size:14px}
.frame>.ph strong{font-weight:600}
.frame>.ph .meta{margin-left:auto;font:500 12.5px var(--mono);color:var(--ink-2)}
.frame .bd{padding:16px;min-width:0}
.frame svg{display:block;width:100%;height:auto}
.st-t{font:600 16px var(--sans);margin:0 0 8px}
.desc{background:var(--paper);border-radius:var(--r-s);padding:12px 14px;margin-top:12px;min-height:84px;font-size:15.5px;color:var(--ink-2)}
.desc pre{margin:10px 0 0;font-size:12.5px;border-left-color:var(--rule-strong)}
.nav{display:flex;gap:8px;margin-top:12px;align-items:center}
button{font:500 14px var(--sans);color:var(--ink);background:var(--surface);border:1px solid var(--rule-strong);border-radius:var(--r-s);padding:6px 14px;cursor:pointer}
button:hover:not(:disabled){border-color:var(--struct);color:var(--struct)}
button:disabled{opacity:.4;cursor:default}
button.primary,button[aria-pressed="true"]{background:var(--struct);border-color:var(--struct);color:var(--surface)}
button.primary:hover:not(:disabled),button[aria-pressed="true"]:hover{color:var(--surface);filter:brightness(1.1)}
input,select{font:500 14px var(--sans);color:var(--ink);background:var(--surface);border:1px solid var(--rule-strong);border-radius:var(--r-s);padding:6px 10px}
input[type=number]{width:84px}
input[type=range],input[type=checkbox]{accent-color:var(--struct)}
.controls{display:flex;flex-wrap:wrap;gap:8px;align-items:center}
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(140px,1fr));gap:8px;margin-top:12px}
.stat{background:var(--paper);border-radius:var(--r-s);padding:8px 12px}
.stat span{display:block;font-size:13px;color:var(--ink-2)}
.stat b{font:600 20px var(--sans);font-variant-numeric:tabular-nums}
.legend{display:flex;flex-wrap:wrap;gap:6px 14px;font-size:13px;color:var(--ink-2);margin-top:12px}
.legend span{display:inline-flex;align-items:center;gap:6px}
.legend i{width:14px;height:14px;border-radius:3px;border:2px solid;display:inline-block}
.fine{font-size:13.5px;color:var(--ink-2);margin:10px 0 0}  /* chú thích nhỏ dưới widget */

/* svg text */
.tb{font:600 14px var(--sans)} .t{font:400 13px var(--sans)} .ts{font:400 12px var(--sans)} .tm{font:500 12.5px var(--mono)}
.lbl{fill:var(--ink-2);font:400 12.5px var(--sans)}

/* callouts */
.note{border-left:3px solid var(--hot-line);background:var(--hot-bg);padding:12px 16px;border-radius:0 var(--r-s) var(--r-s) 0;margin:18px 0;max-width:720px;font-size:16px}
.note strong{color:var(--hot)}
.senior{border:1.5px solid var(--struct);border-radius:var(--r-m);padding:14px 18px;margin:22px 0;max-width:720px;background:var(--surface)}
.senior h4{font-size:16px;margin-bottom:6px;color:var(--struct)}
.senior p:last-child,.senior ul:last-child{margin-bottom:0}
details{background:var(--surface);border:1px solid var(--rule);border-radius:var(--r-s);padding:10px 14px;margin:10px 0;max-width:720px}
details summary{cursor:pointer;font-weight:600}
details[open] summary{margin-bottom:8px}
details.answer{background:var(--paper);border-style:dashed;margin:10px 0 0}
details.answer summary{font-weight:500;color:var(--struct)}
.tag{display:inline-block;font:500 12px var(--sans);color:var(--ink-2);border:1px solid var(--rule-strong);border-radius:999px;padding:0 8px;margin-right:6px;vertical-align:1px}

/* hero brief: mục tiêu, cần biết trước, trạng thái */
.brief{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:12px 24px;background:var(--surface);border:1px solid var(--rule);border-radius:var(--r-m);padding:14px 18px;max-width:920px;margin:0 0 8px;font-size:15px}
.brief h4{font-size:14px;color:var(--struct);margin:0 0 4px}
.brief ul{margin:0;padding-left:18px}
.brief p{margin:0}

.mobile-toc{display:none}
@media (max-width:900px){
  .shell{grid-template-columns:1fr;padding:0 16px;gap:0}
  nav.toc{display:none}
  .mobile-toc{display:block;margin-top:20px}
  main{padding-top:32px}
  .frame .bd{padding:12px}
  body{font-size:16px}
}
```

## Markup that goes with it

- Hero: `<div class="hero"><h1>…</h1><p class="lede">…</p><div class="brief">…</div></div>` at the top of `<main>`. The brief has three blocks, each `<div><h4>Mục tiêu</h4><ul>…</ul></div>`, then Cần biết trước, then Trạng thái. Section order and headings are in `content.md`.
- Recall question: `<details><summary><span class="tag">Dự đoán</span>Short title</summary><p>Question</p><details class="answer"><summary>Xem đáp án</summary><p>…</p></details></details>`.
- Section: `<section id="sN"><header><span class="num">0N</span><h2>…</h2></header> … </section>`.
- Mistake callout: `<div class="note"><strong>Lỗi hay gặp:</strong> …</div>`.
- Senior callout: `<div class="senior"><h4>Góc nhìn senior</h4><p>…</p></div>`, a short title after a colon is allowed (`Góc nhìn senior: điểm tách không phải lúc nào cũng ở giữa`).
- Tables wider than the reading column go in `<div class="tablewrap">`.
- A small note under a widget (data source, assumptions) is `<p class="fine">`. `.note` is only the mistake callout.

## What a page may add

- Widget CSS after the base block: SVG state classes (`.n.struct`, `.n.row`, …), page-specific layouts such as a ledger or a matrix.
- State classes use only the tokens above. No new hex values in a page; if a topic needs a state the palette cannot express, add the color here first, in both light and dark, so the next page can use it too.
