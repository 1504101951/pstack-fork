---
name: principle-attack-the-premise
description: "当两个或更多共用同一前提的修复在同一道关卡上都失败时适用。先把前提写下来并直接测试它，再去写下一个依赖这个前提的修复。"
disable-model-invocation: true
---

# Attack the Premise

When two or more fixes that share one premise have failed the same gate, suspect the premise, not the fixes.

- Write the premise down: the one sentence every failed fix assumed.
- Test it before the next fix. Find an observation that would come out differently if the premise were false, and make it. Look at how the failures are distributed, not only at how large they are.
- If the evidence contradicts the premise, look for what the failures share that it did not predict. If one part always lands on the losing side, change what puts it there instead of adding a mechanism that cleans up after it.

Do not start the next fix before the premise is written down and tested.
