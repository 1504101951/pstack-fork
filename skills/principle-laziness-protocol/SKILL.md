---
name: principle-laziness-protocol
description: "在重构、评估 diff 大小，或者忍不住想添加抽象、分层或信号传递时适用。倾向于删除，以及能解决问题的最小改动。"
disable-model-invocation: true
---

# Laziness Protocol

- **Consolidate decisions.** Do not repeat the same choice in several places. Put it behind one source of truth and pass the result as a simple flag.
- **Minimize the diff.** Make the smallest change that solves the problem. Fewer lines beat "elegant" boilerplate.
