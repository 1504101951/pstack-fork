---
name: principle-never-block-on-the-human
description: "当你想在可逆的工作上问 'should I do X?' 时适用。"
disable-model-invocation: true
---

# Never Block on the Human

The human supervises asynchronously. Agents must stay unblocked. Make reasonable decisions, proceed, and let the human course-correct after the fact. Since code changes are reversible and reviewable, a wrong decision usually costs less than blocking.

- Proceed, then present. Do the work, show the result. Don't ask "should I do X?" Do X, explain why.
- Make the system self-healing. When you notice a problem, log it and fix it in the next round.
- A deploy, deleted data, a force-push to a shared branch, or a message to someone outside the run still requires confirmation.
- Reversible actions (write code, edit notes, split tasks) should proceed without blocking.
- Product direction comes from the human. Execution should not block.
