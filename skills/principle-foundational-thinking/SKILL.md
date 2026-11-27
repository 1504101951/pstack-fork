---
name: principle-foundational-thinking
description: "在写逻辑之前适用：选择核心类型和数据结构、安排脚手架与功能工作的先后顺序、追问并发的参与者共享什么。把数据结构定对，下游代码就会变得显而易见。"
disable-model-invocation: true
---

# Foundational Thinking

Get the data shape right before writing logic. Define core types early, trace every access pattern, and choose structures that match the dominant paths. DRY the structure, not every line.

Before sharing state between actors, ask what happens if another actor modifies it concurrently. If the answer is not "nothing", isolate.

Scaffold first. Whatever helps every later phase (CI, tests, shared types) goes first, after removing dead code. Keep commits small and single-purpose.
