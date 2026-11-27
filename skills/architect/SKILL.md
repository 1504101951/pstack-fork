---
name: architect
description: "Sketch types, signatures, and module structure before code, then stay in the loop while implementation fills in. Use for /architect, 'architect this', 'design this', or non-trivial work where jumping to code would lock in the wrong shape."
disable-model-invocation: true
---

# Architect

Before writing code, trace every system the change touches, then sketch two different shapes for it (types, signatures, module boundaries) and pick the one where each piece of state has one owner, each task has one way to do it, and callers need to know least. Redesign instead of patching if workarounds repeat.

For a large or contested design, run the **arena** skill instead of sketching alone.

To use another skill or principle this file names, read its SKILL.md from the skills folder that holds this skill, resolved from this file's real path: `../<name>/SKILL.md` for a skill, and `../principle-<name>/SKILL.md` for a principle named without its `principle-` prefix. Then follow it.
