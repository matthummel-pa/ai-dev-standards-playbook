#!/usr/bin/env python3
"""Build docs/index.html from docs/src/template.html and the live repo content.

Reads the frontmatter of every rule, skill, command and agent and renders one card each,
so a new SKILL.md shows up on the docs site without touching the HTML.

  python3 scripts/build-docs.py            # writes docs/index.html
  python3 scripts/build-docs.py --check    # exit 1 if docs/index.html is stale (CI)
"""
import html
import pathlib
import re
import sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
TEMPLATE = ROOT / "docs" / "src" / "template.html"
OUT = ROOT / "docs" / "index.html"


def frontmatter(path: pathlib.Path) -> tuple[dict, str]:
    """Return (frontmatter dict, body). Handles scalar values and simple YAML lists."""
    text = path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n?", text, re.S)
    if not m:
        return {}, text
    data: dict = {}
    key = None
    for line in m.group(1).splitlines():
        km = re.match(r"^([A-Za-z_-]+):\s*(.*)$", line)
        if km:
            key, val = km.group(1), km.group(2).strip()
            data[key] = [] if val == "" else val.strip('"')
        elif key and line.strip().startswith("- ") and isinstance(data.get(key), list):
            data[key].append(line.strip()[2:].strip('"'))
    return data, text[m.end():]


def esc(s: str) -> str:
    return html.escape(s, quote=True)


def code_list(items: list[str]) -> str:
    return ", ".join(f"<code>{esc(i)}</code>" for i in items)


def first_para(body: str, limit: int = 220) -> str:
    """First non-heading, non-empty paragraph of a markdown body, flattened and truncated."""
    for block in re.split(r"\n\s*\n", body.strip()):
        line = " ".join(l.strip() for l in block.splitlines() if l.strip())
        if not line or line.startswith("#"):
            continue
        line = re.sub(r"^[-*]\s+", "", line)
        line = re.sub(r"\*\*(.+?)\*\*", r"\1", line)
        return line if len(line) <= limit else line[: limit - 1].rstrip() + "…"
    return ""


def card(kind: str, title: str, desc: str, meta: str = "", when: str = "") -> str:
    parts = [f'<article class="card {kind}"><h4>{esc(title)}</h4>']
    if desc:
        parts.append(f"<p>{desc}</p>")
    if when:
        parts.append(f'<p class="when">{when}</p>')
    if meta:
        parts.append(f'<p class="loads">{meta}</p>')
    parts.append("</article>")
    return "".join(parts)


def rules() -> str:
    out = []
    core = ROOT / "rules" / "core.md"
    fm, body = frontmatter(core)
    bullets = [re.sub(r"`", "", l[2:]) for l in body.splitlines() if l.startswith("- ")]
    out.append(card("rule", "core.md", esc(" ".join(bullets)),
                    f"Loads: every session · {core.stat().st_size} bytes (budget 1 KB)"))
    for p in sorted((ROOT / "rules").rglob("*.md")):
        if p.name == "core.md":
            continue
        fm, body = frontmatter(p)
        title = p.relative_to(ROOT / "rules").as_posix()
        heading = next((l[2:] for l in body.splitlines() if l.startswith("# ")), title)
        desc = esc(fm.get("description") or first_para(body))
        paths = fm.get("paths") if isinstance(fm.get("paths"), list) else []
        out.append(card("rule", title, f"<strong>{esc(heading)}.</strong> {desc}",
                        f"Paths: {code_list(paths)}" if paths else "Loads: by path"))
    return "\n      ".join(out)


def skills() -> str:
    out = []
    for p in sorted((ROOT / "skills").glob("*/SKILL.md")):
        fm, _ = frontmatter(p)
        desc = fm.get("description", "")
        # Split "What it is. Use when …" into the card body and a "Use:" line.
        m = re.search(r"\bUse (?:when|before|for|it when)\b.*$", desc)
        use = m.group(0) if m else ""
        main = desc[: m.start()].strip() if m else desc
        out.append(card("skill", fm.get("name", p.parent.name), esc(main),
                        f"{esc(use)}" if use else "Loads: body on use"))
    return "\n      ".join(out)


def commands() -> str:
    out = []
    for p in sorted((ROOT / "commands").rglob("*.md")):
        fm, _ = frontmatter(p)
        ns = p.relative_to(ROOT / "commands").with_suffix("").as_posix().replace("/", ":")
        hint = fm.get("argument-hint", "")
        title = f"/{ns} {hint}".strip()
        out.append(card("cmd", title, esc(fm.get("description", ""))))
    return "\n      ".join(out)


def agents() -> str:
    out = []
    for p in sorted((ROOT / "agents").glob("*.md")):
        fm, _ = frontmatter(p)
        tools = fm.get("tools", "")
        desc = fm.get("description", "")
        m = re.search(r"\bUse (?:proactively|when)\b.*?\.", desc)
        use = m.group(0) if m else ""
        main = desc.replace(use, "").strip() if use else desc
        meta = f"{esc(use)}" if use else ""
        if tools:
            meta = (meta + " · " if meta else "") + f"Tools: {esc(tools)}"
        out.append(card("agent", f"agents/{p.name}", esc(main), meta))
    return "\n      ".join(out)


def changes(limit: int = 6) -> str:
    """Rows for the What's new table: version, date and the first bullet of each release."""
    text = (ROOT / "CHANGELOG.md").read_text(encoding="utf-8")
    rows = []
    for m in re.finditer(r"^## \[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2})\n(.*?)(?=^## \[|\Z)", text, re.S | re.M):
        ver, date, body = m.groups()
        bullets = [re.sub(r"`([^`]+)`", r"<code>\1</code>", esc(l[2:].strip())).replace("&lt;code&gt;", "<code>")
                   for l in body.splitlines() if l.startswith("- ")]
        first = bullets[0] if bullets else ""
        first = re.sub(r"<code>([^<]*)</code>", lambda mm: f"<code>{mm.group(1)}</code>", first)
        # Keep the highlight short.
        plain = re.sub(r"<[^>]+>", "", first)
        if len(plain) > 180:
            first = esc(plain[:179].rstrip()) + "…"
        rows.append(f"<tr><td><strong>{esc(ver)}</strong></td><td>{esc(date)}</td><td>{first}</td></tr>")
        if len(rows) >= limit:
            break
    return "\n      ".join(rows)


def build() -> str:
    tpl = TEMPLATE.read_text(encoding="utf-8")
    version = (ROOT / "VERSION").read_text().strip()
    return (tpl.replace("{{VERSION}}", esc(version))
               .replace("{{RULES}}", rules())
               .replace("{{SKILLS}}", skills())
               .replace("{{COMMANDS}}", commands())
               .replace("{{AGENTS}}", agents())
               .replace("{{CHANGES}}", changes()))


if __name__ == "__main__":
    rendered = build()
    if "--check" in sys.argv:
        if OUT.exists() and OUT.read_text(encoding="utf-8") == rendered:
            print("docs/index.html is up to date")
            sys.exit(0)
        print("docs/index.html is stale: run python3 scripts/build-docs.py and commit it")
        sys.exit(1)
    OUT.write_text(rendered, encoding="utf-8")
    print(f"Wrote {OUT.relative_to(ROOT)} ({len(rendered.encode())} bytes)")
