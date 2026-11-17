# Cursor environments

One plugin, one toolchain script, and project facts in each repo. Do not copy the rule files into a theme.

## What a cloud agent loads

| Channel | Every project | Cloud agent |
| --- | --- | --- |
| Plugin (Customize → Add from GitHub → this repo) | Yes, after one install | Yes. Skills, rules, and commands sync when the agent starts. Start a new agent after a playbook merge. |
| Account user rules (Customize → Rules) | Yes | Yes. They follow the account. |
| `scripts/sync.sh` → `~/.cursor/rules/playbook/` and `~/.claude` | That machine | No. Those files stay on the machine. |
| `.cursor/rules`, `AGENTS.md`, `.cursor/environment.json` in a project | That repo | Yes, for that repo. Rules in a second repo do not apply while the agent works in the first. |
| `scripts/cloud-install.sh` | When `install` runs it | During the Build, not during chat. |

Cloning this repo next to a theme does not load its rules into that theme. A single-repo environment cannot gain a second repo later. `repositoryDependencies` only adds git credentials for a same-owner GitHub repo. This playbook is public, so the install line below is enough.

## Three layers

1. **Standards.** The plugin. One install for every project.
2. **Toolchain.** The Build `install` line below. Front-end-only repos skip `cloud-install.sh` and run `npm ci` only.
3. **Project facts.** That repo's `AGENTS.md` and `.cursor/rules`: text domain, local commands, target size, theme switch, and deploy. When a playbook rule disagrees, follow the project.

Use one environment per project. Environment secrets apply to every repo in that environment.

A saved personal environment wins over a committed `.cursor/environment.json`. New saved environments start with "skip environment.json". Point the environment at the file, then run a Build. Self-hosted machines never read the file.

`install` must be idempotent. It runs from the repo root when Cursor creates a Build. Keep dev servers out of it.

## Install line

Pin the playbook commit. Bump the pin when `scripts/cloud-install.sh` changes behavior. `20954e12d0f08dc21a14b3dc2fd0e3fc0e1a392d` is the 1.6.0 script.

WordPress repo (Composer and npm):

```bash
curl -fsSL https://raw.githubusercontent.com/matthummel-pa/ai-dev-standards-playbook/20954e12d0f08dc21a14b3dc2fd0e3fc0e1a392d/scripts/cloud-install.sh | bash
composer install --no-interaction
npm ci
```

Drop `npm ci` when there is no `package-lock.json`. Drop `composer install` when there is no `composer.json`. Drop `cloud-install.sh` for a front-end-only repo. Node is already on the image.

`templates/project/.cursor/environment.json` is that WordPress line. `scripts/new-project.sh` copies it only when the repo does not already have one.

## Project facts on the cloud image

Add this to the project's `AGENTS.md`. Do not replace the facts already there.

```markdown
## Cursor Cloud specific instructions

Standards come from the Cursor playbook plugin. Do not copy those rules into this repo. When a playbook rule and a project rule disagree, follow this repo for the text domain, local commands, target size, theme switch, and deploy.

Studio is not on the image. Run pint, phpcs, and `npm run build`. Do not install WordPress unless the task asks.
```
