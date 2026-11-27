---
name: how
description: "适用于 \"how does X work\"、改动前的代码讲解，以及位置/归属/分层类问题（\"where should this live\"、\"which package owns this\"、\"is this the right layer\"）。讲解子系统架构、运行时流程和上手所需的心智模型。涉及动机时用 why。"
disable-model-invocation: true
---

# How

Explore the codebase to answer "how does X work?" questions.

If the scope is ambiguous, state your interpretation and explore. The user can redirect.

## 1. Explain

Spawn one read-only subagent (tell it not to edit files) that explores and explains in one pass. Give it the user's question and this brief:

> You are writing an architectural explanation for a senior engineer. Explore the codebase and write an explanation that a senior engineer unfamiliar with this area could read and walk away with a solid mental model. They should understand the architecture well enough to start working in it confidently. You have read-only access to the codebase.

## 2. Present

Present the subagent's output. Light edits for clarity or context from the conversation are fine. Do not substantially rewrite it.
