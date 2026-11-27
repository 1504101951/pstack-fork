---
name: principle-build-the-lever
description: "适用于任何非平凡的工作，不只是批量工作：编辑、迁移、分析、检查。构建出完成它或证明它的工具（codemod、脚本、生成器，或你的子智能体遵循的技能），而不是手工去做。这个工具就是审阅者可以重新运行的产物。"
disable-model-invocation: true
---

# Build the Lever

When the work isn't trivial, build the tool that does it (a codemod, script, generator, or rerunnable check) instead of doing it by hand. The bar is triviality, not repetition. Skip the tool only for a couple of obvious edits.

- Do the first unit by hand, then build the tool and prove it by rerunning it on that unit. Make it safe to rerun.
- A deterministic tool beats fan-out. When you do fan out, write the recipe, the verification contract, and the fences as one skill the delegates read and cannot edit.
- Applying this produces a file. No script, codemod, generator, or delegate skill in the diff means you didn't apply it. Commit it when the work outlives the session.
- Build the smallest script that does or proves the job, never a framework.
