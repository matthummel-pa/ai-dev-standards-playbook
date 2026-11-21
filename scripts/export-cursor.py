#!/usr/bin/env python3
"""Write Cursor project rules from rules/** so the two copies cannot drift.

Claude rules use `paths:`. Cursor rules (.cursor/rules/**/*.mdc) use `globs`
and `alwaysApply`. core.md is the only always-on rule. Edit rules/, then run:

    python3 scripts/export-cursor.py

`validate.py` runs this with --check.
"""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
SRC = ROOT / "rules"
DEST = ROOT / ".cursor" / "rules"


def split_front(text):
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        return "", text
    return m.group(1), text[m.end():]


def paths_of(front):
    paths, capture = [], False
    for line in front.splitlines():
        if line.startswith("paths:"):
            capture = True
            rest = line.split(":", 1)[1].strip().strip("'\"")
            if rest:
                paths.append(rest)
            continue
        if capture:
            item = re.match(r"^\s+-\s+(.+)$", line)
            if item:
                paths.append(item.group(1).strip().strip("'\""))
            elif line.strip():
                capture = False
    return paths


def expand_braces(pattern):
    """Turn `{a,b}` into separate globs so a comma-separated `globs` string stays unambiguous."""
    match = re.search(r"\{([^{}]+)\}", pattern)
    if not match:
        return [pattern]
    return [
        item
        for option in match.group(1).split(",")
        for item in expand_braces(pattern[: match.start()] + option + pattern[match.end() :])
    ]


def title_of(body, fallback):
    for line in body.splitlines():
        if line.startswith("# "):
            return line[2:].strip()
    return fallback


def quote(value):
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def render(src: pathlib.Path) -> str:
    front, body = split_front(src.read_text(encoding="utf-8"))
    title = title_of(body, src.stem)
    if src.name == "core.md":
        head = f"---\ndescription: {quote(title)}\nalwaysApply: true\n---\n"
    else:
        globs = [item for pattern in paths_of(front) for item in expand_braces(pattern)]
        if not globs:
            raise SystemExit(f"{src.relative_to(ROOT)}: no paths to convert")
        head = (
            f"---\ndescription: {quote(title)}\n"
            f"globs: {quote(','.join(globs))}\n"
            f"alwaysApply: false\n---\n"
        )
    if not body.startswith("\n"):
        body = "\n" + body
    return head + body


def outputs():
    found = {}
    for src in sorted(SRC.rglob("*.md")):
        rel = src.relative_to(SRC).with_suffix(".mdc")
        found[rel.as_posix()] = render(src)
    return found


def main():
    check = "--check" in sys.argv
    found = outputs()
    if check:
        problems = []
        for rel, text in found.items():
            path = DEST / rel
            if not path.is_file() or path.read_text(encoding="utf-8") != text:
                problems.append(rel)
        extra = []
        if DEST.is_dir():
            for path in DEST.rglob("*.mdc"):
                rel = path.relative_to(DEST).as_posix()
                if rel not in found:
                    extra.append(rel)
        if problems or extra:
            print("Cursor rules are stale. Run: python3 scripts/export-cursor.py")
            for rel in problems:
                print(f"  out of date: .cursor/rules/{rel}")
            for rel in extra:
                print(f"  extra: .cursor/rules/{rel}")
            sys.exit(1)
        print(f"Cursor rules match ({len(found)} files)")
        return
    for rel, text in found.items():
        path = DEST / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="utf-8")
        print(f"wrote .cursor/rules/{rel}")


if __name__ == "__main__":
    main()
