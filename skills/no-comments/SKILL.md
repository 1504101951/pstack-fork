---
name: no-comments
description: "Spawn Comment Sicko, fix accepted findings, and encode claimed constraints."
disable-model-invocation: true
---

# No comments

Spawn Comment Sicko. Act on accepted findings.

Defer to Comment Sicko's fresh perspective.

## Scope

Use the caller's files or diff. Otherwise use the current diff against the base branch, default `main`, including the working tree.

## Steps

1. Spawn the `comment-sicko` subagent. If this agent has no subagent with that name, stop and tell the user to run `/setup-pstack`. The first line of its brief is `Read <absolute path of ../poteto-mode/worker.md>`, resolved from this file's real path. Pass the scope. Do not restate its rules.
2. Check its report and diff against comment-sicko's rules.
   - Reject any edit to application code, any change outside the scope, and any deletion of a comment that a keep exception protects.
   - Reject a `MUST KILL` flag whose reason is wrong, or that marks deliberate code as a problem. A flag on a surprise in our own code stays a valid `MUST KILL`. Do not restore that comment.
   - Keep a comment only with proof that it describes something we cannot change.
   - Look for lint and TypeScript suppressions in scope that it missed. A suppression that protects correctness or safety is a `MUST KILL`.
   - Restore a deleted comment only when a keep exception covers it exactly and you can show the proof in scope.
   - Before you accept a kill or a keep that rests on a thin `IMPORTANT` or `do not remove` note, trace its symbol or run `/why` on it. If a kill stays ambiguous, leave the comment deleted. If a keep is refuted or still ambiguous, delete it.
   - If you reject the report, revert its changes and rerun it once with the failure named. If you reject the second report too, report it open and fail `/no-comments`.
3. Fix trivial accepted flags directly by deleting a dead path, dropping a parameter, or using the real API. If any fix needs a shape, run `/architect` once for the accepted set and surrounding code. Stop at the sketch. Architect shapes. Step 4 implements.
4. Implement the smallest root-cause fix in scope. Remove every named workaround. If the root cause is out of scope, land the smallest in-scope fix and report the rest open. The **principle-fix-root-causes** and **principle-redesign-from-first-principles** skills guide intent only. Neither authorizes widening the fence nor fixing instances outside it. Never bolt on symptom guards.
5. Constraint comments say `do not remove`, `do not change wording`, or `talk to X before changing`. Leave keeps about things we cannot change. For the rest, add the cheapest in-scope type, runtime check, test, or CI lint that enforces the constraint, then delete the comment. These changes are reversible, so do not wait for approval. When no in-scope encoding exists, delete the comment, report the constraint open, and sketch the out-of-scope work.
6. Report the deletion count, restored comments, reruns, architect sketch, fixes, encodings, unenforced constraints, and other open work.
