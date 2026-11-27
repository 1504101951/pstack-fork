### Authoring or modifying a skill

**You own the skill's voice.**

1. Confirm when the skill is used and how it is invoked: by slash command only, or also picked by the agent on its own. If the request and the conversation do not say, ask the user both and wait for the answers before writing.
2. Write the SKILL.md in the Agent Skills format: a folder with SKILL.md whose frontmatter has `name` and `description`. For a skill invoked by slash command only, set `disable-model-invocation: true` in the frontmatter and add `agents/openai.yaml` containing `policy:` with `allow_implicit_invocation: false`.
3. Validate the skill: frontmatter has `name` and `description`, the invocation settings match step 1, referenced files exist, cross-skill links resolve.
4. Test cases if structural. Skip if subjective.
5. Run **Opening a PR**.

When in doubt, delete. Keep only prose that changes a decision. Tell it to do the thing and skip the reason. Explain only when the rule is confusing without one. Match tone to scope. Point at structural sources (types, READMEs, config) per the **encode-lessons-in-structure** principle skill. Delegate to other skills by path. Don't restate. A workflow you keep hitting but isn't captured → propose a new skill.

**Reply:** summary of the skill, key design decisions, validation notes.
