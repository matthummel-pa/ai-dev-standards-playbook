#!/usr/bin/env python3
"""Checks that keep the playbook cheap to load and safe to publish.

- rules/**: frontmatter parses; only core.md may load always (no `paths`), and it stays under 1 KB.
- skills/*/SKILL.md: has `name` (matching its folder) and a `description`.
- commands/**: has a `description`.
- Nothing public names private infrastructure (edit BLOCKLIST for your own hosts).
"""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
BLOCKLIST = [r"hummelwp\.com", r"\bu\d{6,}\b", r"application password", r"admin\s*/\s*password",
             r"ghp_[A-Za-z0-9]{20,}", r"github_pat_", r"BEGIN (OPENSSH|RSA) PRIVATE KEY"]
errors = []

def front(path):
    text = path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m:
        return {}, text
    data = {}
    for line in m.group(1).splitlines():
        km = re.match(r"^([A-Za-z_-]+):\s*(.*)$", line)
        if km:
            data[km.group(1)] = km.group(2)
    return data, text

for p in sorted((ROOT / "rules").rglob("*.md")):
    fm, text = front(p)
    if "paths" not in fm and p.name != "core.md":
        errors.append(f"{p.relative_to(ROOT)}: always-on rule; add `paths:` or make it a skill")
    if p.name == "core.md" and len(text.encode()) > 1024:
        errors.append(f"{p.relative_to(ROOT)}: {len(text.encode())} bytes; core must stay under 1 KB")

for p in sorted((ROOT / "skills").glob("*/SKILL.md")):
    fm, _ = front(p)
    if fm.get("name") != p.parent.name:
        errors.append(f"{p.relative_to(ROOT)}: name must be '{p.parent.name}'")
    if not fm.get("description"):
        errors.append(f"{p.relative_to(ROOT)}: missing description")
    if ": " in fm.get("description", "") and not fm["description"].startswith('"'):
        errors.append(f"{p.relative_to(ROOT)}: quote the description (it contains ': ')")

for p in sorted((ROOT / "commands").rglob("*.md")):
    fm, _ = front(p)
    if not fm.get("description"):
        errors.append(f"{p.relative_to(ROOT)}: missing description")

for p in ROOT.rglob("*"):
    if p.is_file() and ".git" not in p.parts and p.suffix in {".md", ".sh", ".yml", ".json", ".py"} and p.name != "validate.py":
        text = p.read_text(encoding="utf-8", errors="ignore")
        for pat in BLOCKLIST:
            if re.search(pat, text, re.I):
                errors.append(f"{p.relative_to(ROOT)}: matches private pattern /{pat}/")

if errors:
    print("\n".join(errors))
    sys.exit(1)
print("Playbook OK")
