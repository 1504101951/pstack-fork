---
name: principle-explain-the-number
description: "在你测量之前，以及在你信任、汇报或依据一个测得的数字行动之前适用：加速比、性能退化、吞吐量、延迟或评测结果。找出是什么限制了它，并排除它测量的其实不是你以为的那项工作。"
disable-model-invocation: true
---

# Explain the Number

- **Write the decision before you run.** Name the result that would change it, and the noise floor. Stop when the run-to-run spread is larger than the effect.
- **Ask "why not double?"** Name the resource or code path that bounds the result, from a profile or counters taken during a run. A guess from reading the code is not a limiter.
- **List what else the number could be measuring** (errors, skipped or cached work, code that never ran, an untuned side, noise, a piece too small to matter) and rule out each one with evidence.
- **Keep the run count, the spread, and the limiter with the number.**

For an eval result, ask whether every run did the task, whether the gap holds across trials and models, and whether the scenario matters.
