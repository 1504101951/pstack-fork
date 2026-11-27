---
name: principle-fix-root-causes
description: "调试时适用。把每个症状追溯到系统最先出错的地方，并在那里修复。只有当它所处理的状态本身是合法的，防护才算修复。"
disable-model-invocation: true
---

# Fix Root Causes

Fix the fault, not the place where it surfaced. The root cause is the first place the system did something it should not do, or failed to handle a state it should handle.

- Reproduce first. Ask "why" until the answer is a wrong decision in the code. When stuck, instrument and read the actual state.
- Ask whether the state that triggered the symptom is legitimate. If it is, handle it where the code broke. If it should never exist, a check there hides the bug, so find what produced it. Guards, retries, swallowed errors, clamped values, and discarded state are the usual ways to hide a bug.
- Fix the pattern, not the instance. Find every place with the same fault.
- If the deciding fact took a deep dig, propose the cheap, always-on signal that would have shown it at first look.
