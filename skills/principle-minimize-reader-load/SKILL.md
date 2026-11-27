---
name: principle-minimize-reader-load
description: "在审查或调整难以追踪的代码时适用。数一数从问题到答案之间有几层，以及读者脑子里有多少隐藏状态；折叠只有一个调用者的包装层，缩小可变状态的作用域。"
disable-model-invocation: true
---

# Minimize Reader Load

Reader load is the work a reader must do to understand code. It has two independent axes: layers to trace between the question and the answer, and hidden or mutable state to hold in their head. Guard both.

- Collapse layers that only forward: wrappers with one caller, adapters with no second implementation, pass-through methods. Inline them.
- Shrink state scope: returns over mutations, locals over fields, fields over module state, module state over globals. Derive instead of sync.
- Name an invariant once at the boundary, not in every consumer.

The test: can a new reader answer "where does X come from?" and "what can change X?" in under 30 seconds? If not, cut layers or cut state.
