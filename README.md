# pstack-fork

pstack-fork is a fork of [pstack](https://github.com/cursor/plugins/tree/b1fbf4b60ac6813b4583ccc356850dafcf492665/pstack) by Lauren Tan ([poteto](https://x.com/poteto)), taken from `cursor/plugins` at commit `b1fbf4b`. It is released under the MIT license. The original copyright and permission notice is kept in [LICENSE](./LICENSE).

pstack is a set of skills for writing less, higher-quality code with agents you can parallelize with confidence. pstack-fork supports Antigravity CLI (`agy`), Claude Code and Codex. The skills describe what to do, not which vendor tool to call, so each agent uses its own tools.

## Install

Run this in a terminal on macOS or Linux:

```bash
curl -fsSL https://raw.githubusercontent.com/1504101951/pstack-fork/main/install.sh | bash
```

[`install.sh`](./install.sh) clones the repo to `~/pstack-fork`, detects which of Claude Code, Codex and agy you have, asks which to install, and installs pstack-fork into each one you pick as a plugin. Run the same command again to update.

| Agent | What the installer does | Invoke a skill |
| --- | --- | --- |
| Claude Code | Adds `~/pstack-fork` as the `pstack-fork` marketplace and installs the plugin. It loads from the clone, so updating the clone updates the plugin. | `/pstack-fork:<name>` |
| Codex | Adds `~/pstack-fork` as the `pstack-fork` marketplace. Finish in Codex: run `/plugins`, open `pstack-fork`, select **Install plugin**, then start a new session. | Type `@` and pick the skill |
| agy | Runs `agy plugin install ~/pstack-fork`. | `/<name>` |

Plugin skills are namespaced in Claude Code, so a skill of yours with the same name, such as `tdd`, keeps working next to the pstack-fork one.

Each skill is marked to run only when you invoke it, in the form Claude Code and Codex read. agy has no setting that keeps a skill from being picked automatically, so it may start a pstack-fork skill without a slash command.

## Get started

1. Run the [`setup-pstack`](./skills/setup-pstack/SKILL.md) skill. It creates the `poteto-agent` and `comment-sicko` subagents in your agent, on the model and effort you pick. Run it again after you update pstack-fork.
2. Start rigorous work with the [`poteto-mode`](./skills/poteto-mode/SKILL.md) skill. It matches your task to a playbook and runs the other skills as the steps need them.

In Claude Code:

```
/pstack-fork:poteto-mode this pr has a subtle bug where the scroll drifts every 750ms even when idle. repro first, then fix and verify.
```

## Skills

Invoke a skill the way your agent does, as in the table under Install. `poteto-mode` also calls the ones its playbooks need.

**Entry and setup**

- [`poteto-mode`](./skills/poteto-mode/SKILL.md): matches a task to one of 16 playbooks and runs them.
- [`setup-pstack`](./skills/setup-pstack/SKILL.md): creates the subagents pstack spawns by name.

**Understand**

- [`in-your-own-words`](./skills/in-your-own-words/SKILL.md): restates your goal and problem before work starts.
- [`sharpen`](./skills/sharpen/SKILL.md): frames the task the way a top expert would, then does it.
- [`reframe`](./skills/reframe/SKILL.md): teaches the expert terms for what you are building and rewrites your description with them.
- [`how`](./skills/how/SKILL.md): explains how a subsystem works.
- [`why`](./skills/why/SKILL.md): explains why code is shaped the way it is, from commits and PR discussions.
- [`teach`](./skills/teach/SKILL.md): combines how and why into one plain explanation.
- [`recall`](./skills/recall/SKILL.md): rebuilds your recent working context.
- [`ketchup`](./skills/ketchup/SKILL.md): catches you up on what happened since your last message.
- [`bro`](./skills/bro/SKILL.md): restates the last message in plain words.

**Design and analyze**

- [`blast-radius`](./skills/blast-radius/SKILL.md): finds what a change could break and proves the fact its safety rests on.
- [`architect`](./skills/architect/SKILL.md): settles types, signatures and module shape before code.
- [`arena`](./skills/arena/SKILL.md): runs several attempts from different angles and merges the best parts.
- [`figure-it-out`](./skills/figure-it-out/SKILL.md): designs a playbook when none fits.

**Verify**

- [`tdd`](./skills/tdd/SKILL.md): failing test first, then the fix, when a cheap test exists.
- [`create-verification-skill`](./skills/create-verification-skill/SKILL.md) and [`maintain-verification-skill`](./skills/maintain-verification-skill/SKILL.md): generate and maintain a project skill that drives the app as a user and keeps evidence.
- [`create-formal-verification-skill`](./skills/create-formal-verification-skill/SKILL.md) and [`maintain-formal-verification-skill`](./skills/maintain-formal-verification-skill/SKILL.md): formal checks for races, state machines and similar code.
- [`statechart`](./skills/statechart/SKILL.md): checks a TLA+ model and draws it as a Mermaid statechart.

**Clean and write**

- [`no-comments`](./skills/no-comments/SKILL.md): spawns `comment-sicko` to strip comments and encode real constraints.
- [`unslop`](./skills/unslop/SKILL.md): removes AI writing tells.
- [`technical-writing`](./skills/technical-writing/SKILL.md): a layered standard for docs, RFCs, PR descriptions and commit messages.

**Record and improve**

- [`show-me-your-work`](./skills/show-me-your-work/SKILL.md): keeps a reviewable decision log for long or unattended work.
- [`reflect`](./skills/reflect/SKILL.md): turns this conversation's lessons into edits on existing skills.
- [`correct`](./skills/correct/SKILL.md): finds repeated agent mistakes and makes them impossible.
- [`automate-me`](./skills/automate-me/SKILL.md): drafts your own `-mode` skill from your history.

## Principles

poteto-mode grounds its decisions in 21 principles. Each is a `principle-*` skill in [`skills/`](./skills/), indexed in [poteto-mode](./skills/poteto-mode/SKILL.md#principles).

## Subagents

[`agent-prompts/`](./agent-prompts/) holds the prompts for `poteto-agent`, which runs delegated work inside a `poteto-mode` run, and `comment-sicko`, which reviews comments for `no-comments`. The `setup-pstack` skill installs them into your agent.

## License

MIT. See [LICENSE](./LICENSE).
