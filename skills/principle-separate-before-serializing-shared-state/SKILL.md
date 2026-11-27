---
name: principle-separate-before-serializing-shared-state
description: "当并发的参与者可能写入同一个文件、分支、键或状态对象时适用。先消除共享；只有当存在唯一的共享写入者确实是一条不变量时，才从结构上做串行化。"
disable-model-invocation: true
---

# Separate Before Serializing Shared State

When concurrent actors might write the same file, branch, key, or object, first ask whether they need one shared object or are publishing independent facts. Default to giving each actor its own file, key, branch, or state directory, and merge only where the state is read. Two workers writing their own field into one `state.json` is still shared mutation.

Only when one shared write target is a real invariant, serialize access structurally (a lockfile, a single writer, sequential phases, compare-and-swap). Instructions are not concurrency control, and "we need a lock" is a smell to check first.
