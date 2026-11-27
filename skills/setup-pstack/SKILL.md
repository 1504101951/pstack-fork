---
name: setup-pstack
description: Create the subagents pstack spawns by name (`poteto-agent`, `comment-sicko`) as user-level subagents of the current agent, with the model and reasoning effort the user picks. Use for setup-pstack, "set up pstack", "configure pstack subagents", or when a pstack skill reports a missing `poteto-agent` or `comment-sicko`.
disable-model-invocation: true
---

# Setup pstack

pstack spawns two subagents by name. `poteto-agent` runs delegated work inside a `poteto-mode` run. `comment-sicko` reviews comments for **no-comments**. Their prompts ship with pstack. This skill installs them as user-level subagents of the agent you are running in, with the model and effort the user picks.

This skill relies on you knowing your own agent's subagent format and user-level folder. If a subagent you wrote does not show up in step 4, tell the user which folder and format you used.

## Steps

### 1. Read the prompts

Read `../../agent-prompts/poteto-agent.md` and `../../agent-prompts/comment-sicko.md`, relative to this file. Each has frontmatter with `name` and `description`, then the prompt body. If either file is missing, stop and tell the user which path you tried.

### 2. Ask for model and effort

For each subagent, ask the user which model it runs on and at what reasoning effort. Offer the models your agent lets a subagent use, plus "same as the parent session", which is the default. Ask about effort only if your agent lets a subagent set it. Otherwise say once that your agent has no per-subagent effort setting, and skip it.

### 3. Write the subagents

Write each subagent as a user-level subagent in your agent's own format and folder:

- `name` and `description` come from the source frontmatter, unchanged.
- The prompt body comes from the source file, verbatim.
- Set the model and effort the user picked. For "same as the parent session", leave the model unset or use your agent's inherit value.
- Unless there is a special case, a subagent inherits the parent agent's tools.
- Write no field your agent does not support.

Overwrite an existing subagent with the same name, so a re-run updates it.

### 4. Check and report

Confirm your agent now lists both subagents. Tell the user each file you wrote, the model and effort it got, and any field you skipped. Say that new sessions pick them up, and that a subagent missing from the list means step 3 used the wrong folder or format.

The installed subagents are copies. After updating pstack, run the `setup-pstack` skill again so they match the new prompts.
