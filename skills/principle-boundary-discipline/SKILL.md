---
name: principle-boundary-discipline
description: "在接入校验、错误处理或框架适配器时适用。把防护集中在系统边界（CLI、配置、网络、外部 API）；信任内部类型，把业务逻辑放在纯函数里。"
disable-model-invocation: true
---

# Boundary Discipline

Validate, narrow types, and handle errors where data crosses a system boundary (CLI args, config files, external APIs, network). Inside, trust the types: no re-validation and no redundant nil checks. Parse raw data into domain types at the boundary, and keep transport and framework types out of the public surface. Business logic lives in pure functions with no framework dependencies. The shell that calls them is thin.

Two tests. Is this data crossing a boundary right now? If not, the validation is redundant. Can this be a pure function the shell just calls? If yes, extract it.
