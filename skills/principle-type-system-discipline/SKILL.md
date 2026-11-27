---
name: principle-type-system-discipline
description: "在设计类型、审查函数签名，或用任何静态类型语言写代码时适用。让非法状态无法表示，给有语义的原始类型加品牌（brand），在边界处解析外部数据，穷尽所有变体，从权威的 schema 推导。"
disable-model-invocation: true
---

# Type System Discipline

Make the compiler reject impossible states, mismatched primitives, and unhandled variants.

- **Brand semantic primitives.** If two arguments share a primitive type but mean different things, give each its own type. Validate once at creation.
- **External data is untyped until parsed.** JSON, RPC payloads, CLI args, config, environment variables, and database rows go through a parse function at the boundary that returns the typed model.
- **Derive types from authoritative schemas.** When a schema file owns a shape, derive the type from it instead of hand-rolling a parallel one.
