#!/usr/bin/env python3
"""Check a topic page: JS errors, steppers, mobile overflow, a11y basics.

Usage:
    python3 check_page.py topics/<slug>/index.html --out <dir>

Requires: pip install playwright && playwright install chromium
Exit code 0 when clean, 1 when problems were found.
"""
import argparse
import asyncio
import pathlib
import sys

from playwright.async_api import async_playwright

IGNORED_ERRORS = ("ERR_TUNNEL_CONNECTION_FAILED", "ERR_NAME_NOT_RESOLVED",
                  "ERR_INTERNET_DISCONNECTED", "fonts.g")


def relevant(msg: str) -> bool:
    return not any(s in msg for s in IGNORED_ERRORS)


async def check(path: pathlib.Path, out: pathlib.Path) -> list[str]:
    problems: list[str] = []
    url = path.resolve().as_uri()
    out.mkdir(parents=True, exist_ok=True)

    async with async_playwright() as p:
        browser = await p.chromium.launch()

        # Desktop pass
        page = await browser.new_page(viewport={"width": 1280, "height": 900})
        errors: list[str] = []
        page.on("pageerror", lambda e: errors.append(f"pageerror: {e}"))
        page.on("console", lambda m: errors.append(f"console: {m.text}")
                if m.type == "error" else None)
        await page.goto(url)
        await page.wait_for_timeout(800)
        await page.screenshot(path=str(out / "desktop.png"), full_page=False)

        # Steppers: click "next" until disabled, checking the description.
        frames = await page.query_selector_all(".frame")
        for idx, frame in enumerate(frames):
            fid = await frame.get_attribute("id") or f"frame-{idx}"
            nxt = await frame.query_selector('button[data-d="1"]')
            if nxt:
                total = 0
                while total < 60:
                    desc = await frame.query_selector(".st-d")
                    text = (await desc.inner_text()).strip() if desc else ""
                    if desc and not text:
                        problems.append(f"{fid}: empty description at step {total + 1}")
                    pre = await frame.query_selector("pre:not([hidden])")
                    if pre and len((await pre.inner_text()).strip()) < 6:
                        problems.append(f"{fid}: suspicious code box at step {total + 1}: "
                                        f"{(await pre.inner_text()).strip()!r}")
                    if await nxt.is_disabled():
                        break
                    await nxt.click()
                    total += 1
                if total >= 60:
                    problems.append(f"{fid}: next button never disabled (wraps around?)")
            else:
                # Simulators and playgrounds: press each button once.
                for b in await frame.query_selector_all("button"):
                    if await b.is_enabled():
                        await b.click()
                        await page.wait_for_timeout(50)
                await page.wait_for_timeout(2500)
            await frame.screenshot(path=str(out / f"{fid}.png"))

        # Accessibility basics
        for svg in await page.query_selector_all("svg"):
            info = await svg.evaluate(
                "e=>({hidden:e.getAttribute('aria-hidden')==='true'||!!e.closest('[aria-hidden=true]'),"
                "name:e.getAttribute('aria-label')||(e.querySelector('title')||{}).textContent||'',"
                "role:e.getAttribute('role')})")
            if not info["hidden"] and not info["name"].strip():
                problems.append("svg without aria-label/<title> (or aria-hidden)")
        for b in await page.query_selector_all("button"):
            if not (await b.inner_text()).strip() and not await b.get_attribute("aria-label"):
                problems.append("button without text or aria-label")
        has_reduced = await page.evaluate(
            "[...document.styleSheets].some(s=>{try{return [...s.cssRules].some(r=>r.cssText.includes('prefers-reduced-motion'))}catch(e){return false}})")
        if not has_reduced:
            problems.append("no prefers-reduced-motion rule")
        has_dark = await page.evaluate(
            "[...document.styleSheets].some(s=>{try{return [...s.cssRules].some(r=>r.cssText.includes('prefers-color-scheme'))}catch(e){return false}})")
        if not has_dark:
            problems.append("no prefers-color-scheme rule (dark mode)")

        problems += [e for e in errors if relevant(e)]

        # Mobile pass
        mobile = await browser.new_page(viewport={"width": 390, "height": 844})
        merr: list[str] = []
        mobile.on("pageerror", lambda e: merr.append(f"mobile pageerror: {e}"))
        await mobile.goto(url)
        await mobile.wait_for_timeout(800)
        width = await mobile.evaluate("document.documentElement.scrollWidth")
        if width > 390:
            problems.append(f"horizontal overflow on mobile: scrollWidth {width}px > 390px")
        await mobile.screenshot(path=str(out / "mobile.png"), full_page=False)
        problems += merr

        # Dark mode screenshot for a visual review
        dark = await browser.new_page(viewport={"width": 1280, "height": 900},
                                      color_scheme="dark")
        await dark.goto(url)
        await dark.wait_for_timeout(800)
        await dark.screenshot(path=str(out / "desktop-dark.png"))

        await browser.close()
    return problems


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("page", type=pathlib.Path)
    ap.add_argument("--out", type=pathlib.Path, default=pathlib.Path("page-check"))
    args = ap.parse_args()
    if not args.page.exists():
        sys.exit(f"not found: {args.page}")
    problems = asyncio.run(check(args.page, args.out))
    # de-duplicate while keeping order
    seen, unique = set(), []
    for p in problems:
        if p not in seen:
            seen.add(p)
            unique.append(p)
    print(f"Screenshots: {args.out.resolve()}")
    if unique:
        print(f"{len(unique)} problem(s):")
        for p in unique:
            print(f"  - {p}")
        sys.exit(1)
    print("OK: no problems found")


if __name__ == "__main__":
    main()
